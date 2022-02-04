//
//  Profile.swift
//  VKClient
//
//  Created by Сергей Черных on 24.08.2021.
//

import UIKit
import RealmSwift

struct Profile: Codable {
    let userID: Int
    let firstName: String
    let lastName: String
    let avatarUrlString: String
    let networkStatus: Int?
    let friendStatus: Int?
        
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrlString =  "photo_100"
        case networkStatus = "online"
        case friendStatus = "friend_status"
    }
}

class RealmProfile: Object {
    @Persisted(primaryKey: true) var userID: Int = 0
    @Persisted(indexed: true) var firstName: String = ""
    @Persisted(indexed: true) var lastName: String = ""
    @Persisted var avatarUrlString: String = ""
    @Persisted var networkStatus: Int = 0
    @Persisted var friendStatus: Int = 0
    @Persisted var userPhotos: List<RealmUserPhoto>
    
    convenience init(friend: Profile) {
        self.init()
        self.userID = friend.userID
        self.firstName = friend.firstName
        self.lastName = friend.lastName
        self.avatarUrlString = friend.avatarUrlString
        self.networkStatus = friend.networkStatus ?? 0
        self.friendStatus = friend.friendStatus ?? 0
    }
}

struct ProfileForAdapter: Equatable {
    let userID: Int
    let firstName: String
    let lastName: String
    let avatarUrlString: String
    let networkStatus: Int
    let friendStatus: Int

    init(rlmProfile: RealmProfile) {
        self.userID = rlmProfile.userID
        self.firstName = rlmProfile.firstName
        self.lastName = rlmProfile.lastName
        self.avatarUrlString = rlmProfile.avatarUrlString
        self.networkStatus = rlmProfile.networkStatus
        self.friendStatus = rlmProfile.friendStatus
    }

}
