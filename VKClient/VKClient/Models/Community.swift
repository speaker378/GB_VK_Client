//
//  Community.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

struct Community {
    var name: String
    var image: UIImage?
    var members: UInt
}

extension Community: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}


var myCommunitysList = [
    Community(name: "Братство кольца", image: UIImage(named: "ring"), members: 9),
    Community(name: "Королевство Гондор", image: UIImage(named: "gondor"), members: 21_381),
]

var allCommunitysList = [
    Community(name: "Таверна Гарцующий пони", image: UIImage(named: "pony"), members: 509),
    Community(name: "Мордор", image: UIImage(named: "mordor"), members: 30_946),
]
