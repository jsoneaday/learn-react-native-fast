use crate::common::entities::messages::model::MessageWithFollowingAndBroadcastQueryResult;
use crate::common::app_state::AppState;
use crate::common::entities::messages::repo::{InsertMessageFn, QueryMessageFn, QueryMessagesFn, QueryMessageImageFn, InsertResponseMessageFn, QueryResponseMessagesFn, LikeMessageFn};
use crate::routes::errors::error_utils::UserError;
use crate::routes::output_id::OutputId;
use crate::routes::profiles::model::ProfileShort;
use actix_web::HttpResponse;
use actix_web::web::Bytes;
use actix_web::{web, web::{Path, Json}};
use super::model::{MessageResponder, MessageQuery, MessageByFollowingQuery, MessageResponders, MessageResponsesQuery};
use super::model_create_msg::MessageCreateMultipart;
use super::model_create_response_msg::MessageCreateResponseMultipart;

#[allow(unused)]
pub async fn create_message<T: InsertMessageFn>(app_data: web::Data<AppState<T>>, params: MessageCreateMultipart) -> Result<OutputId, UserError> {  
    let max = 141; 
    let body = if params.body.len() < max {
        &params.body[..]
    } else {
        &params.body[..max]
    };
    
    let group_type = params.group_type.clone() as i32;
    let result = app_data.db_repo.insert_message(params.user_id, body, group_type, params.broadcasting_msg_id, params.image.clone()).await;
    match result {
        Ok(id) => Ok(OutputId { id }),
        Err(e) => Err(e.into())
    }
}

#[allow(unused)]
pub async fn create_response_message<T: InsertResponseMessageFn>(app_data: web::Data<AppState<T>>, params: MessageCreateResponseMultipart) -> Result<OutputId, UserError> {  
    let max = 141; 
    let body = if params.body.len() < max {
        &params.body[..]
    } else {
        &params.body[..max]
    };
    
    let group_type = params.group_type.clone() as i32;
    let result = app_data.db_repo.insert_response_message(params.user_id, body, group_type, params.original_msg_id, params.image).await;
    match result {
        Ok(id) => Ok(OutputId { id }),
        Err(e) => Err(e.into())
    }
}

#[allow(unused)]
pub async fn get_message_image<T: QueryMessageImageFn>(app_data: web::Data<AppState<T>>, path: Path<MessageQuery>) -> actix_web::Result<actix_web::HttpResponse> {
    let message_result = app_data.db_repo.query_message_image(path.id).await;

    match message_result {
        Ok(option_image) => {
            match option_image {
                Some(msg_image) => {
                    let file_bytes: Bytes = Bytes::from(msg_image.image);

                    // Return the file as a response
                    Ok(HttpResponse::Ok()
                        .content_type("image/jpeg") // Set the appropriate content type for your file
                        .body(file_bytes))
                },
                None => Ok(HttpResponse::NotFound().body("File not found"))
            }
        },
        Err(e) => Ok(HttpResponse::NotFound().body("File not found"))
    }
}

#[allow(unused)]
pub async fn get_message<T: QueryMessageFn>(app_data: web::Data<AppState<T>>, path: Path<MessageQuery>) -> Result<Option<MessageResponder>, UserError> {
    let message_result = app_data.db_repo.query_message(path.id).await;

    match message_result {
        Ok(message) => {
            match message {
                Some(msg) => {
                    Ok(Some(convert(&msg)))
                },
                None => Ok(None)
            }
        },
        Err(e) => Err(e.into())
    }
}

#[allow(unused)]
pub async fn get_messages<T: QueryMessagesFn>(app_data: web::Data<AppState<T>>, body: Json<MessageByFollowingQuery>) 
    -> Result<MessageResponders, UserError>  {
    let page_size = match body.page_size {
        Some(ps) => ps,
        None => 10
    };
    
    let mut messages_result = app_data.db_repo.query_messages(
        body.follower_id, body.last_updated_at, page_size
    ).await;
    
    let mut msg_collection: Vec<MessageResponder> = vec![];
    match messages_result {
        Ok(messages) => {
            messages
                .iter()
                .for_each(|msg| {
                    msg_collection.push(convert(msg))
                });

            Ok(MessageResponders(msg_collection))
        },
        Err(e) => {
            println!("route get_messages error: {:?}", e);
            Err(e.into())
        }
    }
}

pub async fn get_response_messages<T: QueryResponseMessagesFn>(app_data: web::Data<AppState<T>>, body: Json<MessageResponsesQuery>) 
    -> Result<MessageResponders, UserError>  {
    let page_size = match body.page_size {
        Some(ps) => ps,
        None => 10
    };
    
    let messages_result = app_data.db_repo.query_response_messages(
        body.original_msg_id, body.last_updated_at, page_size
    ).await;
    
    let mut msg_collection: Vec<MessageResponder> = vec![];
    match messages_result {
        Ok(messages) => {
            messages
                .iter()
                .for_each(|msg| {
                    msg_collection.push(convert(msg))
                });

            Ok(MessageResponders(msg_collection))
        },
        Err(e) => {
            println!("route get_response_messages error: {:?}", e);
            Err(e.into())
        }
    }
}

pub async fn like_message<T: LikeMessageFn>(app_data: web::Data<AppState<T>>, path: Path<MessageQuery>) -> Result<String, UserError> {
    let like_result = app_data.db_repo.like_message(path.id).await;

    match like_result {
        Ok(_) => Ok("".to_string()),
        Err(e) => Err(e.into())
    }
}

fn convert(message: &MessageWithFollowingAndBroadcastQueryResult) -> MessageResponder {
    MessageResponder {
        id: message.id,
        updated_at: message.updated_at,
        body: message.body.clone(),
        likes: message.likes,
        responses: message.responses,
        has_image: message.image.is_some(),
        broadcasting_msg: match message.broadcast_msg_id {
            Some(id) => {
                Some(Box::new(MessageResponder { 
                    id,
                    updated_at: message.broadcast_msg_updated_at.unwrap(),
                    body: message.broadcast_msg_body.clone(),
                    likes: message.broadcast_msg_likes.unwrap(),
                    responses: message.broadcast_msg_responses,
                    has_image: message.broadcast_msg_image.is_some(),
                    broadcasting_msg: None ,
                    profile: ProfileShort {
                        id: message.broadcast_msg_user_id.unwrap(),
                        user_name: message.broadcast_msg_user_name.clone().unwrap(),
                        full_name: message.broadcast_msg_full_name.clone().unwrap()
                    }
                }))
            },
            None => None
        },
        profile: ProfileShort {
            id: message.id,
            user_name: message.user_name.clone(),
            full_name: message.full_name.clone()
        }
    }
}


#[cfg(test)]
mod tests {
    use chrono::{Utc, DateTime};
    use actix_web::web::Json;
    use async_trait::async_trait;
    use crate::{
        common::entities::messages::{repo::{QueryMessagesFn, InsertMessageFn}, model::MessageWithFollowingAndBroadcastQueryResult}, 
        common_tests::actix_fixture::{get_app_data, get_fake_message_body},
        routes::messages::{message_route::create_message, model_create_msg::MessageCreateMultipart, model::MessageGroupTypes},
        routes::{errors::error_utils::UserError, messages::{message_route::get_messages, model::MessageByFollowingQuery}}, 
    };
    use fake::faker::{internet::en::Username, name::en::{FirstName, LastName}};
    use fake::Fake;

    fn get_fake_message_with_following(id: Option<i64>) -> MessageWithFollowingAndBroadcastQueryResult {
        MessageWithFollowingAndBroadcastQueryResult {
            id: if let Some(id) = id { id } else { 0 },
            updated_at: Utc::now(),
            body: None,
            likes: 1,
            responses: None,
            image: None,
            msg_group_type: MessageGroupTypes::Public as i32,
            user_id: 0,
            user_name: Username().fake(),
            full_name: format!("{} {}", FirstName().fake::<String>(), LastName().fake::<String>()),
            avatar: None,
            broadcast_msg_id: None,
            broadcast_msg_updated_at: None,
            broadcast_msg_body: None,
            broadcast_msg_likes: None,
            broadcast_msg_responses: None,
            broadcast_msg_image: None,
            broadcast_msg_user_id: None,
            broadcast_msg_user_name: None,
            broadcast_msg_full_name: None,
            broadcast_msg_avatar: None,
        }
    }

    mod test_mod_create_message_and_check_id {        
        use super::*;

        const ID: i64 = 22;
        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl InsertMessageFn for TestRepo {            
            async fn insert_message(
                &self,
                user_id: i64,
                body: &str,
                group_type: i32,
                broadcasting_msg_id: Option<i64>,
                image: Option<Vec<u8>>
            ) -> Result<i64, sqlx::Error> {
                Ok(ID)
            }
        }

        #[tokio::test]
        async fn test_create_message_and_check_id() {
            let repo = TestRepo;
            let app_data = get_app_data(repo).await;

            let result = create_message(app_data, 
                MessageCreateMultipart{ 
                    user_id: 0, 
                    body: get_fake_message_body(None), 
                    group_type: crate::routes::messages::model::MessageGroupTypes::Circle, 
                    broadcasting_msg_id: None, 
                    image: None 
                }
            ).await;

            assert!(!result.is_err());
            assert!(result.ok().unwrap().id == ID);
        }
    }

    mod test_mod_create_response_message_and_check_id {        
        use crate::{common::entities::messages::repo::InsertResponseMessageFn, routes::messages::{message_route::create_response_message, model_create_response_msg::MessageCreateResponseMultipart}};

        use super::*;

        const ID: i64 = 22;
        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl InsertResponseMessageFn for TestRepo {            
            async fn insert_response_message(
                &self,
                user_id: i64,
                body: &str,
                group_type: i32,
                original_msg_id: i64,
                image: Option<Vec<u8>>
            ) -> Result<i64, sqlx::Error> {
                Ok(ID)
            }
        }

        #[tokio::test]
        async fn test_create_message_and_check_id() {
            let repo = TestRepo;
            let app_data = get_app_data(repo).await;

            let result = create_response_message(app_data, 
                MessageCreateResponseMultipart{ 
                    user_id: 0, 
                    body: get_fake_message_body(None), 
                    group_type: crate::routes::messages::model::MessageGroupTypes::Circle, 
                    original_msg_id: 1, 
                    image: None 
                }
            ).await;

            assert!(!result.is_err());
            assert!(result.ok().unwrap().id == ID);
        }
    }

    mod test_mod_create_message_failure_returns_correct_error {      
        use crate::routes::errors::error_utils::UserError;
        use super::*;

        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl InsertMessageFn for TestRepo {            
            async fn insert_message(
                &self,
                user_id: i64,
                body: &str,
                group_type: i32,
                broadcasting_msg_id: Option<i64>,
                image: Option<Vec<u8>>
            ) -> Result<i64, sqlx::Error> {
                Err(sqlx::Error::PoolTimedOut)
            }
        }

        #[tokio::test]
        async fn test_create_message_failure_returns_correct_error () {
            let repo = TestRepo;
            let app_data = get_app_data(repo).await;

            let result = create_message(
                app_data,
                MessageCreateMultipart{ 
                    user_id: 0, 
                    body: get_fake_message_body(None), 
                    group_type: crate::routes::messages::model::MessageGroupTypes::Circle, 
                    broadcasting_msg_id: None, 
                    image: None 
                }
            ).await;

            assert!(result.is_err());
            assert!(result.err().unwrap() == UserError::InternalError);
        }
    }

    mod test_mod_get_message_failure_returns_correct_error {      
        use actix_web::web::Path;
        use crate::{routes::{errors::error_utils::UserError, messages::{message_route::get_message, model::MessageQuery}}, common::entities::messages::{repo::QueryMessageFn, model::MessageWithFollowingAndBroadcastQueryResult}};
        use super::*;

        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl QueryMessageFn for TestRepo {            
            async fn query_message(&self, id: i64) -> Result<Option<MessageWithFollowingAndBroadcastQueryResult>, sqlx::Error> {
                Err(sqlx::Error::ColumnNotFound("na".to_string()))
            }
        }

        #[tokio::test]
        async fn test_get_message_failure_returns_correct_error () {
            let repo = TestRepo;
            let app_data = get_app_data(repo).await;

            let result = get_message(app_data, Path::from(MessageQuery{ id: 0 })).await;

            assert!(result.is_err());
            assert!(result.err().unwrap() == UserError::InternalError);
        }
    }

    mod test_mod_get_message_and_check_id {      
        use actix_web::web::Path;        
        use crate::{
            routes::messages::{message_route::get_message, model::MessageQuery}, 
            common::entities::messages::{repo::QueryMessageFn, model::MessageWithFollowingAndBroadcastQueryResult}
        };
        use super::*;

        const ID: i64 = 22;
        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl QueryMessageFn for TestRepo {            
            async fn query_message(&self, id: i64) -> Result<Option<MessageWithFollowingAndBroadcastQueryResult>, sqlx::Error> {
                Ok(Some(get_fake_message_with_following(Some(ID))))
            }
        }

        #[tokio::test]
        async fn test_get_message_and_check_id() {
            let repo = TestRepo;
            let app_data = get_app_data(repo).await;

            let result = get_message(app_data, Path::from(MessageQuery{ id: 0 })).await;

            assert!(!result.is_err());
            assert!(result.ok().unwrap().unwrap().id == ID);
        }
    }

    mod test_mod_get_messages_failure_returns_correct_error {        
        use super::*;

        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl QueryMessagesFn for TestRepo {            
            async fn query_messages(
                &self, 
                user_id: i64,
                last_updated_at: DateTime<Utc>,
                page_size: i16
            ) -> Result<Vec<MessageWithFollowingAndBroadcastQueryResult>, sqlx::Error> {
                Err(sqlx::Error::ColumnNotFound("na".to_string()))
            }
        }

        #[tokio::test]
        async fn test_get_messages_failure_returns_correct_error () {
            let repo = TestRepo;
            let app_data = get_app_data(repo).await;

            let result = get_messages(app_data, Json(MessageByFollowingQuery { follower_id: 0, last_updated_at: Utc::now(), page_size: None })).await;

            assert!(result.is_err());
            assert!(result.err().unwrap() == UserError::InternalError);
        }
    }

    mod test_mod_get_messages_and_check_id {
        use crate::{
            routes::messages::{model::MessageByFollowingQuery, message_route::get_messages}, 
            common::entities::base::DbRepo
        };
        use super::*;

        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl QueryMessagesFn for TestRepo {            
            async fn query_messages(
                &self, 
                user_id: i64,
                last_updated_at: DateTime<Utc>,
                page_size: i16
            ) -> Result<Vec<MessageWithFollowingAndBroadcastQueryResult>, sqlx::Error> {
                Ok(vec![get_fake_message_with_following(None)])
            }
        }

        #[tokio::test]
        async fn test_get_messages_and_check_id() {
            let repo = DbRepo::init().await;
            let app_data = get_app_data(repo).await;

            let result = get_messages(app_data, Json(MessageByFollowingQuery { follower_id: 1, last_updated_at: Utc::now(), page_size: None })).await;

            match result {
                Ok(messages) => assert!(messages.0.len() > 0),
                Err(e) => {
                    panic!("Failed to get_messages {:?}", e);
                }
            };                      
        }
    }

    mod test_mod_get_response_messages_and_check_id {          
        use crate::{
            routes::messages::{model::MessageResponsesQuery, message_route::get_response_messages}, 
            common::entities::{base::DbRepo, messages::{repo::QueryResponseMessagesFn, model::MessageWithFollowingAndBroadcastQueryResult}}
        };
        use super::*;

        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl QueryResponseMessagesFn for TestRepo {            
            async fn query_response_messages(
                &self, 
                original_msg_id: i64,
                last_updated_at: DateTime<Utc>,
                page_size: i16
            ) -> Result<Vec<MessageWithFollowingAndBroadcastQueryResult>, sqlx::Error> {
                Ok(vec![
                    get_fake_message_with_following(None)
                ])
            }
        }

        #[tokio::test]
        async fn test_get_response_messages_and_check_id() {
            let repo = DbRepo::init().await;
            let app_data = get_app_data(repo).await;

            let result = get_response_messages(app_data, Json(MessageResponsesQuery { original_msg_id: 18, last_updated_at: Utc::now(), page_size: None })).await;

            match result {
                Ok(messages) => assert!(messages.0.len() > 0),
                Err(e) => {
                    panic!("Failed to get_messages {:?}", e);
                }
            };                      
        }
    }

    mod test_mod_like_message {
        use actix_web::web::Path;
        use crate::{
            routes::messages::{model::MessageQuery, message_route::like_message}, 
            common::entities::messages::repo::LikeMessageFn
        };
        use super::*;

        struct TestRepo;
        
        #[allow(unused)]
        #[async_trait]
        impl LikeMessageFn for TestRepo {            
            async fn like_message(&self, id: i64) -> Result<(), sqlx::Error> {
                Ok(())
            }
        }

        #[tokio::test]
        async fn test_route_like_message() {
            let repo = TestRepo;
            let app_data = get_app_data(repo).await;

            let result = like_message(app_data, Path::from(MessageQuery { id: 1 })).await;

            match result {
                Ok(_) => (),
                Err(e) => {
                    panic!("Failed to get_messages {:?}", e);
                }
            };                      
        }
    }
}