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

func getImage() -> UIImage {
    let url = URL(string: "https://picsum.photos/400")
    let data = try? Data(contentsOf: url!)
    let image = UIImage(data: data!)
    return image ?? UIImage()
}


var newsList = [
    News(creator: myCommunitysList[1], text: "Simple text for test", images: [getImage()], numberOfViews: UInt.random(in: 0...1000)),
    News(creator: friendsList[2], text: "Any simple text for test", images: [nil], numberOfViews: UInt.random(in: 0...1000)),
    News(creator: friendsList[4], text: "Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text Very long text ", images: [getImage()], numberOfViews: UInt.random(in: 0...1000)),
]
