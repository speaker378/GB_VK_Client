//
//  Photo.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

struct UserPhoto {
    let photo: UIImage?
    var likes = UInt.random(in: 1...8)
    var likeState = false
}

