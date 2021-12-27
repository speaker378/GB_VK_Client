//
//  PhotoViewModelFactory.swift
//  VKClient
//
//  Created by Сергей Черных on 27.12.2021.
//

import Foundation
import RealmSwift

final class PhotoViewModelFactory {
    func constructViewModels(from photo: [RealmUserPhoto]) -> [PhotoViewModel] {
        return photo.compactMap(self.viewModel)
    }
    
    private func viewModel(from photo: RealmUserPhoto) -> PhotoViewModel {
        let size = selectSizePhoto(of: photo.sizes)
        let url = URL(string: size.urlString)
        let likes = photo.countLikes
        let ownerID = photo.ownerID
        let itemID = photo.id
        let stateButton = photo.userLikes == 1 ? true : false

        return PhotoViewModel(likes: likes,
                              ownerID: ownerID,
                              itemID: itemID,
                              stateButton: stateButton,
                              srcImage: url)
    }
        
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
    
}
