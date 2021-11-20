//
//  Photo.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit
import RealmSwift

struct Photo: Codable {
    let id: Int
    let ownerID: Int
    let sizes: [Size]
    let likes: Likes?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
        case likes
    }
    
    static func findUrlInPhotoSizes(sizes: [Size], sizesByPriority: [SizeType]) -> String? {
        var urlString: String?
        let tempDict = sizes.reduce(into: [SizeType : String]()) { result, next in
            result[next.type] = next.urlString
        }
        for sizesByPriority in sizesByPriority {
            urlString = tempDict[sizesByPriority]
            if urlString != nil { break }
        }
        if urlString == nil { urlString = tempDict.first?.value }
        return urlString
    }
}

struct Size: Codable {
    let urlString: String
    let width: Int
    let height: Int
    let type: SizeType
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url"
        case width
        case height
        case type
    }
}

// https://vk.com/dev/photo_sizes
enum SizeType: String, Codable {
    case s, m, x, o, p, q, r, y, z, w
}


class RealmUserPhoto: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted(indexed: true) var ownerID: Int = 0
    @Persisted var sizes: List<RealmSize>
    @Persisted var userLikes: Int = 0
    @Persisted var countLikes: Int = 0
    @Persisted(originProperty: "userPhotos") var assignee: LinkingObjects<RealmProfile>
    
    convenience init(userPhoto: Photo) {
        self.init()
        self.id = userPhoto.id
        self.ownerID = userPhoto.ownerID
        self.sizes.append(objectsIn: userPhoto.sizes.map { RealmSize(size: $0) })
        self.userLikes = userPhoto.likes?.userLikes ?? 0
        self.countLikes = userPhoto.likes?.count ?? 0
    }
}

class RealmSize: Object {
    @Persisted var urlString: String = ""
    @Persisted var type: String = ""
    @Persisted(originProperty: "sizes") var assignee: LinkingObjects<RealmUserPhoto>
    
    convenience init(size: Size) {
        self.init()
        self.urlString = size.urlString
        self.type = size.type.rawValue
    }
}
