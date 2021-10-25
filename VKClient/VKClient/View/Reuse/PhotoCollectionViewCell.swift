//
//  PhotoCollectionViewCell.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: CustomUIImageView!
    @IBOutlet weak var likeControl: Like!
    
    func selectSizePhoto(of sizeList: [Size]) -> Size {
        let sizes = sizeList.map { $0.type }
        
        if sizes.contains("m") {
            let myIndex = Int(sizeList.firstIndex { $0.type == "m" }!)
            return sizeList[myIndex]
        } else if sizes.contains("o") {
            let myIndex = Int(sizeList.firstIndex { $0.type == "o" }!)
            return sizeList[myIndex]
        } else if sizes.contains("s") {
            let myIndex = Int(sizeList.firstIndex { $0.type == "s" }!)
            return sizeList[myIndex]
        }
        
        return sizeList[0]
    }
    
    func configure(userPhoto: UserPhoto) {
        let size = selectSizePhoto(of: userPhoto.sizes)
        if let url = URL(string: size.urlString) {
            photoImageView.loadImage(from: url)
        }
        likeControl.likes = userPhoto.likes.count
        likeControl.ownerID = userPhoto.ownerID
        likeControl.itemID = userPhoto.id
        if userPhoto.likes.userLikes == 1 {
            likeControl.stateButton = true
        }
    }
}
