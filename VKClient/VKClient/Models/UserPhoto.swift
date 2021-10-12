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

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
}

struct Size: Codable {
    let url: String
    let type: String
}
