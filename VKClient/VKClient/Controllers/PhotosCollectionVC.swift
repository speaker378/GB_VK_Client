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
    private let viewModelFactory = PhotoViewModelFactory()
    private var viewModels: [PhotoViewModel] = []
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
            case .initial(let realmPhotos):
                guard let self = self else { return }
                var photos: [RealmUserPhoto] = []
                for realmPhoto in realmPhotos {
                    photos.append(realmPhoto)
                }
                self.viewModels = self.viewModelFactory.constructViewModels(from: photos)
                self.collectionView.reloadData()
            case let .update(realmPhotos, deletions, insertions, modifications):
                var photos: [RealmUserPhoto] = []
                for realmPhoto in realmPhotos {
                    photos.append(realmPhoto)
                }
                self?.collectionView.performBatchUpdates{
                    self?.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    self?.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    self?.collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func fetchUserPhotos() {
        networkService.getAllPhotos(userId: userID) {}
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell  else { return UICollectionViewCell() }
        
        cell.configure(userPhoto: viewModels[indexPath.item])
    
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
