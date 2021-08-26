//
//  Friend.swift
//  VKClient
//
//  Created by Сергей Черных on 24.08.2021.
//

import UIKit

struct Friend {
    let name: String
    let avatar: UIImage?
    let userID: UInt
    private static var counter = 0
    
    init(name: String, avatar: UIImage?) {
        self.name = name
        self.avatar = avatar
        self.userID = UInt(Friend.counter)
        Friend.counter += 1
    }
}
