use crate::common::entities::messages::model::{MessageWithFollowingAndBroadcastQueryResult};
use crate::common::app_state::AppState;
use crate::common::entities::messages::repo::{InsertMessageFn, QueryMessageFn, QueryMessagesFn};
use crate::common::entities::profiles::model::ProfileShort;
use actix_web::{web, web::{Query, Json}, Responder};
use std::error::Error;
use super::model::{MessageResponder, MessagePostJson, MessageQuery, MessageByFollowingQuery};


#[allow(unused)]
pub async fn create_message(app_data: web::Data<AppState>, params: Json<MessagePostJson>) -> Result<impl Responder, Box<dyn Error>> {   
    let body = if params.body.len() < 140 {
        &params.body[..]
    } else {
        &params.body[..140]
    };

    let result = app_data.db_repo.insert_message(&app_data.conn, params.user_id, body, params.broadcasting_msg_id).await;
    match result {
        Ok(id) => Ok(Json(id)),
        Err(e) => Err(Box::new(e))
    }
}

#[allow(unused)]
pub async fn get_message(app_data: web::Data<AppState>, query: Query<MessageQuery>) -> Result<Option<impl Responder>, Box<dyn Error>> {
    let message_result = app_data.db_repo.query_message(&app_data.conn, query.id).await;

    match message_result {
        Ok(message) => {
            match message {
                Some(msg) => {
                    Ok(Some(Json(convert(&msg))))
                },
                None => Ok(None)
            }
        },
        Err(e) => Err(Box::new(e))
    }
}

#[allow(unused)]
pub async fn get_messages(app_data: web::Data<AppState>, query: Query<MessageByFollowingQuery>) -> Result<impl Responder, Box<dyn Error>>  {
    let page_size = match query.page_size {
        Some(ps) => ps,
        None => 10
    };
    let mut messages_result = app_data.db_repo.query_messages(
        &app_data.conn, query.follower_id, query.last_updated_at, page_size
    ).await;
    
    let mut msg_collection: Vec<MessageResponder> = vec![];
    match messages_result {
        Ok(messages) => {
            messages
                .iter()
                .for_each(|msg| {
                    msg_collection.push(convert(msg))
                });

            Ok(Json(msg_collection))
        },
        Err(e) => Err(Box::new(e))
    }
}

fn convert(message: &MessageWithFollowingAndBroadcastQueryResult) -> MessageResponder {
    MessageResponder {
        id: message.id,
        updated_at: message.updated_at,
        body: message.body.clone(),
        likes: message.likes,
        broadcasting_msg: match message.broadcast_msg_id {
            Some(id) => {
                Some(Box::new(MessageResponder { 
                    id,
                    updated_at: message.broadcast_msg_updated_at.unwrap(),
                    body: message.broadcast_msg_body.clone(),
                    likes: message.broadcast_msg_likes.unwrap(),
                    broadcasting_msg: None ,
                    image: message.broadcast_msg_image.clone(),
                    profile: ProfileShort {
                        id: message.broadcast_msg_user_id.unwrap(),
                        user_name: message.broadcast_msg_user_name.clone().unwrap(),
                        full_name: message.broadcast_msg_full_name.clone().unwrap(),
                        avatar: message.broadcast_msg_avatar.clone().unwrap()
                    }
                }))
            },
            None => None
        },
        image: message.image.clone(),
        profile: ProfileShort {
            id: message.id,
            user_name: message.user_name.clone(),
            full_name: message.full_name.clone(),
            avatar: message.avatar.clone()
        }
    }
}
