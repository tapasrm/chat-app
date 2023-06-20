use actix_web::http::header::UPGRADE_INSECURE_REQUESTS;
use chrono::{DateTime, Utc};
use diesel::{
    prelude::*,
    r2d2::{SqliteConnection}
};
use std::{
    collections::{HashMap, HashSet},
    time::SystemTime,
};
use uuid::Uuid;
use crate::models::{Conversation, NewConversation, Room, RoomResponse, User};
type DbError = Box<dyn std::error::Error + Send + Sync>;

fn iso_date() -> String {
    let now = SystemTime::now();
    let now: DateTime<Utc> = now.into();
    return now.to_rfc3339();
}

pub fn find_user_by_phone(
    conn: &mut SqliteConnection, 
    user_phone: String
) -> Result<Option<User>, DbError> {
    use crate::schema::users::dsl::*;
    let user = users 
        .filter(phone.eq(user_phone))
        .first::<User>(conn)
        .optional()?;
    Ok(user)

}