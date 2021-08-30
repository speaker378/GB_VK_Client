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
    var networkStatus: Bool
    private static var counter = 0
    
    init(name: String, avatar: UIImage?, networkStatus: Bool) {
        self.name = name
        self.avatar = avatar
        self.networkStatus = networkStatus
        self.userID = UInt(Friend.counter)
        Friend.counter += 1
    }
}

struct Friends {
   var list = [
        Friend(name: "Aragorn", avatar: UIImage(named: "Aragorn"), networkStatus: true),
        Friend(name: "Boromir", avatar: UIImage(named: "Boromir"), networkStatus: false),
        Friend(name: "Frodo", avatar: UIImage(named: "Frodo"), networkStatus: true),
        Friend(name: "Galadriel", avatar: UIImage(named: "Galadriel"), networkStatus: true),
        Friend(name: "Gandalf", avatar: UIImage(named: "Gandalf"), networkStatus: true),
        Friend(name: "Legolas", avatar: UIImage(named: "Legolas"), networkStatus: true),
    ]
}
