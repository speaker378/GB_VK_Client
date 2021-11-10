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
    let postType: PostTypeEnum
    let text: String
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    let postID: Int
    let type: PostTypeEnum
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case postType = "post_type"
        case text
        case comments, likes, reposts, views
        case postID = "post_id"
        case type
    }
}

enum PostTypeEnum: String, Codable {
    case post = "post"
    case photo = "photo"
    case copy = "copy"
}
