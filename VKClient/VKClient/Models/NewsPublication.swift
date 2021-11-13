//
//  NewsPublication.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import Foundation

// https://vk.com/dev/newsfeed.get

struct NewsPublication: Codable {
    let sourceID: Int // идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы)
    let date: Int // время публикации новости в формате unixtime
    let text: String
    let attachments: [Attachment]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    let postID: Int
    var avatarURL: String?
    var creatorName: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case attachments
        case comments, likes, reposts, views
        case postID = "post_id"
    }
}

struct Attachment: Codable {
    let type: AttachmentType
    let photo: Photo?
}

enum AttachmentType: String, Codable {
    case photo = "photo"
}
