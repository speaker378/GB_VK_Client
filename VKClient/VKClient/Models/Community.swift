//
//  Community.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

struct Community: NewsCreator {
    var name: String
    var avatar: UIImage
    var members: UInt
    
    init(name: String, avatar: UIImage?, members: UInt) {
        self.name = name
        self.avatar = avatar ?? UIImage(systemName: "photo.fill")!
        self.members = members
    }
}

extension Community: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}


var myCommunitysList = [
    Community(name: "Братство кольца", avatar: UIImage(named: "ring"), members: 9),
    Community(name: "Королевство Гондор", avatar: UIImage(named: "gondor"), members: 21_381),
]

var allCommunitysList = [
    Community(name: "Таверна Гарцующий пони", avatar: UIImage(named: "pony"), members: 509),
    Community(name: "Мордор", avatar: UIImage(named: "mordor"), members: 30_946),
]
