//
//  CustomUIImageView.swift
//  VKClient
//
//  Created by Сергей Черных on 12.10.2021.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomUIImageView: UIImageView {
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { responseData, URLResponse, error in
            guard
                let data = responseData,
                let loadedImage = UIImage(data: data)
            else {
                print("couldn't load image from url: \(url)")
                return
            }
            
            imageCache.setObject(loadedImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
        task.resume()
    }
}
