use server_rs::common_tests::actix_fixture::get_app;
use server_rs::common::entities::profiles::model::ProfileCreate;
use server_rs::common::entities::messages::model::{MessagePostJson};
use server_rs::routes::message_route::MessageResponder;
use actix_web::{
    test,
    web::{Json}
};

#[actix_web::test]
async fn test_create_and_get_message() {
    let app = get_app().await;

    // 1. create new profile
    let create_profile_req = test::TestRequest::post().uri("/v1/profile").set_json(Json(ProfileCreate {
        user_name: "user_name".to_string(),
        full_name: "full_name".to_string(),
        description: "description".to_string(),
        region: Some("region".to_string()),
        main_url: Some("main_url".to_string()),
        avatar: Vec::new()
    })).to_request();
    let profile_id = test::call_and_read_body_json::<_, _, i64>(&app, create_profile_req).await;

    // 2. create new message
    const MSG_BODY_STR: &str = "Testing 123";
    let create_msg_req = test::TestRequest::post().uri("/v1/msg").set_json(Json(MessagePostJson {
        user_id: profile_id,
        body: MSG_BODY_STR.clone().to_string()
    })).to_request();
    let msg_id = test::call_and_read_body_json::<_, _, i64>(&app, create_msg_req).await;

    // 3. get the new message
    let get_msg_req = test::TestRequest::get().uri(&format!("/v1/msg?id={}", msg_id)).to_request();
    let get_msg_body = test::call_and_read_body_json::<_, _, Option<MessageResponder>>(&app, get_msg_req).await;

    assert!(get_msg_body.unwrap().body.unwrap().eq(MSG_BODY_STR));
}