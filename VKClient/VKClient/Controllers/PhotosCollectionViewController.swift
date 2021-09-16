//
//  PhotosCollectionViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    var userPhotos: [UserPhoto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...4 {
            userPhotos.append(UserPhoto(photo: getImage(width: 100)))
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell  else { return UICollectionViewCell() }
        
        cell.configure(userPhoto: userPhotos[indexPath.item])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGallery", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let galleryVC = segue.destination as? GalleryViewController else { return }
        let indexPath = sender as! IndexPath
        galleryVC.indexImage = indexPath.item
        galleryVC.photos = userPhotos
    }

}
