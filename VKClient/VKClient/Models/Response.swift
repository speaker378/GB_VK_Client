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
    let count: Int
    let items: [T]
}
