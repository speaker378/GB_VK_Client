//
//  Subsidiary.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit

struct Likes: Codable {
    let userLikes: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

struct Comments: Codable {
    let canPost, count: Int
    let groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case canPost = "can_post"
        case count
        case groupsCanPost = "groups_can_post"
    }
}

struct Reposts: Codable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

struct Views: Codable {
    let count: Int
}
