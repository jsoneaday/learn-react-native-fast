mod common {
    pub mod app_state;
    pub mod entities {
        pub mod message;
        pub mod profile;
        pub mod broadcast;
        pub mod utils;
    }    
}
mod common_test {
    pub mod actix_fixtures;
}
mod routes {
    pub mod message_route;
    pub mod profile_route;
}

use actix_web::{ web, App, HttpServer, Responder };
use routes::profile_route::get_profile;
use std::error::Error;
use crate::common::app_state::AppState;
use crate::routes::message_route::{create_message, get_message, get_messages};
use std::env;
use dotenv::dotenv;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    let port = env::var("PORT").unwrap().parse().unwrap();
    let host = env::var("HOST").unwrap();
    let postgres_host = env::var("POSTGRES_HOST").unwrap();
    let postgres_port = env::var("POSTGRES_PORT").unwrap().parse::<u16>().unwrap();
    let postgres_password = env::var("POSTGRES_PASSWORD").unwrap();
    let postgres_user = env::var("POSTGRES_USER").unwrap();
    let postgres_db = env::var("POSTGRES_DB").unwrap();

    let postgres_url = format!("postgres://{postgres_user}:{postgres_password}@{postgres_host}:{postgres_port}/{postgres_db}");
    
    let conn = sqlx::postgres::PgPool::connect(&postgres_url).await.unwrap();
    let migrate = sqlx::migrate!("./migrations").run(&conn).await;
    match migrate {
        Ok(()) => println!("sqlx migration success"),
        Err(e) => println!("sqlx migration error: {:?}", e)
    };
    
    let result = HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(
                AppState{
                    client: reqwest::Client::new(),
                    conn: conn.clone()
                }
            ))
            .route("/", web::get().to(get_root))
            .service(
                web::scope("/v1")
                    .service(
                        web::resource("/msg")
                            .route(web::get().to(get_message))
                            .route(web::post().to(create_message))
                    )
                    .service(
                        web::resource("/msgs")
                            .route(web::get().to(get_messages))   
                    )
                    .service(
                        web::resource("/profile")
                            .route(web::get().to(get_profile))   
                    )
            )
    })
    .bind((host, port))?
    .run()
    .await;

    result
}

#[allow(unused)]
pub async fn get_root() -> Result<impl Responder, Box<dyn Error>> {
    Ok("Hello World!!!")
}