//
//  Friend.swift
//  VKClient
//
//  Created by Сергей Черных on 24.08.2021.
//

import UIKit

struct Friend: Codable {
    let userID: Int
    let firstName: String
    let lastName: String
    let avatarUrlString: String
    let networkStatus: Int
        
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrlString =  "photo_100"
        case networkStatus = "online"
    }
}
