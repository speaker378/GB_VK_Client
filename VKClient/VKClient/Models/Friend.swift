//
//  Friend.swift
//  VKClient
//
//  Created by Сергей Черных on 24.08.2021.
//

import UIKit

struct Friend: NewsCreator {
    let userID: UInt
    var name: String
    var avatar: UIImage
    var networkStatus: Bool
    private static var counter = 0
    
    init(name: String, avatar: UIImage?, networkStatus: Bool) {
        self.name = name
        self.avatar = avatar ?? UIImage(systemName: "photo.fill")!
        self.networkStatus = networkStatus
        self.userID = UInt(Friend.counter)
        Friend.counter += 1
    }
}


var friendsList = [
    Friend(name: "Aragorn", avatar: UIImage(named: "Aragorn"), networkStatus: true),
    Friend(name: "Boromir", avatar: UIImage(named: "Boromir"), networkStatus: false),
    Friend(name: "Frodo", avatar: UIImage(named: "Frodo"), networkStatus: true),
    Friend(name: "Galadriel", avatar: UIImage(named: "Galadriel"), networkStatus: true),
    Friend(name: "Gandalf", avatar: UIImage(named: "Gandalf"), networkStatus: true),
    Friend(name: "Legolas", avatar: UIImage(named: "Legolas"), networkStatus: true),
    Friend(name: "Bilbo", avatar: UIImage(named: "Bilbo"), networkStatus: true),
    Friend(name: "Merry", avatar: UIImage(named: "Merry"), networkStatus: true),
    Friend(name: "Faramir", avatar: UIImage(named: "Faramir"), networkStatus: true),
    Friend(name: "Gimli", avatar: UIImage(named: "Gimli"), networkStatus: true),
    Friend(name: "Gamling", avatar: UIImage(named: "Gamling"), networkStatus: true),
    Friend(name: "Arwen", avatar: UIImage(named: "Arwen"), networkStatus: true),
]
