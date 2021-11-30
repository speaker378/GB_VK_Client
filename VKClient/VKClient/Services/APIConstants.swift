//
//  APIConstants.swift
//  VKClient
//
//  Created by Сергей Черных on 25.11.2021.
//

import UIKit

final class APIConstants {
    static let shared = APIConstants()
    
    let clientId = "8014425"
    let versionAPI = "5.131"
    let scheme = "https"
    let host = "api.vk.com"
    
    private init() {}
}
