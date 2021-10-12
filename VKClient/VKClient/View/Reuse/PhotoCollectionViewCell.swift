//
//  PhotoCollectionViewCell.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeControl: Like!
    
    func configure(userPhoto: UserPhoto, image: UIImage) {
        photoImageView.image = image
        likeControl.likes = userPhoto.likes.count
        likeControl.ownerID = userPhoto.ownerID
        likeControl.itemID = userPhoto.id
        if userPhoto.likes.userLikes == 1 {
            likeControl.stateButton = true
        }
    }
}
