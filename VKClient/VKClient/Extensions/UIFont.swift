//
//  UIFont.swift
//  VKClient
//
//  Created by Сергей Черных on 27.12.2021.
//

import UIKit

extension UIFont {
    private static var fontCache: [String: UIFont] = [:]
    
    public static func system(size: CGFloat) -> UIFont {
        let key = "\(size)"
        if let cachedFont = self.fontCache[key] {
            return cachedFont
        }
        self.clearFontsCacheIfNeeded()
        let font = UIFont.systemFont(ofSize: size)
        self.fontCache[key] = font
        return font
    }
    
    private static func clearFontsCacheIfNeeded() {
        let maxObjectsCount = 100
        guard self.fontCache.count >= maxObjectsCount else { return }
        fontCache = [:]
        
    }
}
