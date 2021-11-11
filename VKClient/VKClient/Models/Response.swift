//
//  Response.swift
//  VKClient
//
//  Created by Сергей Черных on 08.10.2021.
//

import UIKit

struct VKResponse<T:Codable>: Codable {
    let response: Response<T>
}

struct Response<T: Codable>: Codable {
    let items: [T]
    let profiles: [Profile]?
    let groups: [Group]?
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}
