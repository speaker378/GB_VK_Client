//
//  PhotoCollectionViewCell.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit
import Nuke
import RealmSwift

struct PhotoViewModel {
    let likes: Int
    let ownerID: Int
    let itemID: Int
    let stateButton: Bool
    let srcImage: URL?
}

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeControl: Like!
    
    let optionsNuke = ImageLoadingOptions(
      placeholder: UIImage(systemName: "photo"),
      transition: .fadeIn(duration: 0.25)
    )
    
    func configure(userPhoto: PhotoViewModel) {
        if let url = userPhoto.srcImage {
            Nuke.loadImage(with: url, options: optionsNuke, into: photoImageView)
        }
        likeControl.likes = userPhoto.likes
        likeControl.ownerID = userPhoto.ownerID
        likeControl.itemID = userPhoto.itemID
        likeControl.stateButton = userPhoto.stateButton
    }
}
