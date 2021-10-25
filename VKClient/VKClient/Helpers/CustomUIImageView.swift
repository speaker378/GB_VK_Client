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
    let spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL) {
        image = nil
        addSpinner()
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            removeSpinner()
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
                self.removeSpinner()
            }
        }
        task.resume()
    }
    
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}
