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
        let url = URL(string: "https://picsum.photos/100")
        for _ in 1...4 {
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            userPhotos.append(UserPhoto(photo: image))
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

}
