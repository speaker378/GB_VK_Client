//
//  GalleryViewController.swift
//  VKClient
//
//  Created by Сергей Черных on 11.09.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    var photos = [UserPhoto]()
    var indexImage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = photos[indexImage].photo
    }

}
