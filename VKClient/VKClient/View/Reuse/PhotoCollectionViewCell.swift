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
    
    func configure(userPhoto: UIImage) {
        photoImageView.image = userPhoto
        likeControl.likes = Int.random(in: 1...50)
    }
}
