//
//  Session.swift
//  VKClient
//
//  Created by Сергей Черных on 30.09.2021.
//

final class Session {
    static let shared = Session()
    
    var token = ""
    var userId = 0
    
    private init() {}
}
