//
//  Community.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

struct Community: Codable {
    let id: Int
    let name: String
    let avatarUrlString: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarUrlString = "photo_100"
    }
}
