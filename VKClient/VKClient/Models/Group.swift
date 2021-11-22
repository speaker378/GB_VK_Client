//
//  Group.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit
import RealmSwift

struct Group: Codable {
    let id: Int
    let name: String
    let avatarUrlString: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarUrlString = "photo_100"
    }
}

class RealmGroup: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted(indexed: true) var name: String = ""
    @Persisted var avatarUrlString: String = ""
    
    convenience init(group: Group) {
        self.init()
        self.id = group.id
        self.name = group.name
        self.avatarUrlString = group.avatarUrlString
    }
}
