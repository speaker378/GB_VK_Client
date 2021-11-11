//
//  NewsPublication.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import Foundation

// https://vk.com/dev/newsfeed.get

struct ResponseNews: Codable {
    let response: ItemsNews
}

struct ItemsNews: Codable {
    let items: [NewsPublication]
    let profiles: [ProfileNews]
    let groups: [Group]
    let nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}
struct ProfileNews: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_100"
    }
}

struct NewsPublication: Codable {
    let sourceID: Int // идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы)
    let date: Int // время публикации новости в формате unixtime
    let postType: PostTypeEnum
    let text: String
    let attachments: [Attachment]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    let postID: Int
    let type: PostTypeEnum
    var avatarURL: String?
    var creatorName: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case postType = "post_type"
        case text
        case attachments
        case comments, likes, reposts, views
        case postID = "post_id"
        case type
    }
}

struct Attachment: Codable {
    let type: AttachmentType
    let photo: Photo?
}

enum PostTypeEnum: String, Codable {
    case post = "post"
    case photo = "photo"
    case copy = "copy"
}

enum AttachmentType: String, Codable {
    case album = "album"
    case audio = "audio"
    case link = "link"
    case photo = "photo"
    case video = "video"
}
