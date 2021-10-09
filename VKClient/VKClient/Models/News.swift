//
//  News.swift
//  VKClient
//
//  Created by Сергей Черных on 08.09.2021.
//

import UIKit

protocol NewsCreator {
    var name: String { get set }
    var avatar: UIImage { get set }
}

struct News {
    var creator: NewsCreator
    var text: String?
    var images: [UIImage?]
    var numberOfViews: UInt
}

var newsList = [News]()
