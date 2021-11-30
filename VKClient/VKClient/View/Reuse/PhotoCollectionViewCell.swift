//
//  PhotoCollectionViewCell.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit
import Nuke
import RealmSwift

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeControl: Like!
    
    let optionsNuke = ImageLoadingOptions(
      placeholder: UIImage(systemName: "photo"),
      transition: .fadeIn(duration: 0.25)
    )
    
    func selectSizePhoto(of sizeList: List<RealmSize>) -> RealmSize {
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
    
    func configure(userPhoto: RealmUserPhoto) {
        let size = selectSizePhoto(of: userPhoto.sizes)
        if let url = URL(string: size.urlString) {
            Nuke.loadImage(with: url, options: optionsNuke, into: photoImageView)
        }
        likeControl.likes = userPhoto.countLikes
        likeControl.ownerID = userPhoto.ownerID
        likeControl.itemID = userPhoto.id
        if userPhoto.userLikes == 1 {
            likeControl.stateButton = true
        }
    }
}
