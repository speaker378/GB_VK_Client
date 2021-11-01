//
//  PhotosCollectionVC.swift
//  VKClient
//
//  Created by Сергей Черных on 22.08.2021.
//

import UIKit
import RealmSwift

class PhotosCollectionVC: UICollectionViewController {
    var userID = 0
    private var userPhotos: Results<RealmUserPhoto>?
    private var userPhotoToken: NotificationToken?
    var networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhotos = try? RealmService.load(typeOf: RealmUserPhoto.self).filter("ownerID == \(userID)")
        fetchUserPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userPhotosObserveSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        userPhotoToken?.invalidate()
    }
    
    private func userPhotosObserveSetup() {
        userPhotoToken = userPhotos?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.collectionView.reloadData()
            case .update:
                self?.collectionView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func fetchUserPhotos() {
        networkService.getAllPhotos(userId: userID) {}
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPhotos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell  else { return UICollectionViewCell() }
        
        cell.configure(userPhoto: userPhotos![indexPath.item])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGallery", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let galleryVC = segue.destination as? GalleryVC else { return }
        let indexPath = sender as! IndexPath
        galleryVC.indexMidImage = indexPath.item
        galleryVC.userPhotos = self.userPhotos
    }

}
