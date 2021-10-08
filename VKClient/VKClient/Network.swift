//
//  Network.swift
//  VKClient
//
//  Created by Сергей Черных on 11.09.2021.
//

import UIKit


func getImage(width: Int, height: Int? = nil) -> UIImage {
    let url = URL(string: "https://picsum.photos/\(width)/\(height ?? width)")
    let data = try? Data(contentsOf: url!)
    let image = UIImage(data: data!)
    return image ?? UIImage()
}


func getImage(at url: String) -> UIImage {
    guard let url = URL(string: url),
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data)
    else { return UIImage() }
    return image
}
