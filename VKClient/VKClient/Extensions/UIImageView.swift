//
//  UIImageView.swift
//  VKClient
//
//  Created by Сергей Черных on 12.10.2021.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { responseData, URLResponse, error in
            guard
                let data = responseData,
                let loadedImage = UIImage(data: data)
            else {
                print("couldn't load image from url: \(url)")
                return
            }
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
        task.resume()
    }
}
