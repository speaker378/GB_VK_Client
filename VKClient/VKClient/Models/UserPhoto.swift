//
//  Photo.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

struct UserPhoto: Codable {
    let id: Int
    let ownerID: Int
    let sizes: [Size]
    let likes: Likes

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
        case likes
    }
}

struct Size: Codable {
    let url: String
    let type: String
}

struct Likes: Codable {
    let userLikes: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}
