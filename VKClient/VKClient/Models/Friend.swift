//
//  Friend.swift
//  VKClient
//
//  Created by Сергей Черных on 24.08.2021.
//

import UIKit
import RealmSwift

struct Friend: Codable {
    let userID: Int
    let firstName: String
    let lastName: String
    let avatarUrlString: String
    let networkStatus: Int
    let friendStatus: Int
        
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrlString =  "photo_100"
        case networkStatus = "online"
        case friendStatus = "friend_status"
    }
}

class RealmFriend: Object {
    @Persisted(primaryKey: true) var userID: Int = 0
    @Persisted(indexed: true) var firstName: String = ""
    @Persisted(indexed: true) var lastName: String = ""
    @Persisted var avatarUrlString: String = ""
    @Persisted var networkStatus: Int = 0
    @Persisted var friendStatus: Int = 0
    @Persisted var userPhotos: List<RealmUserPhoto>
    
    convenience init(friend: Friend) {
        self.init()
        self.userID = friend.userID
        self.firstName = friend.firstName
        self.lastName = friend.lastName
        self.avatarUrlString = friend.avatarUrlString
        self.networkStatus = friend.networkStatus
        self.friendStatus = friend.friendStatus
    }
}
