//
//  GalleryVC.swift
//  VKClient
//
//  Created by Сергей Черных on 11.09.2021.
//

import UIKit
import Nuke
import RealmSwift

class GalleryVC: UIViewController {
    
    var userPhotos: Results<RealmUserPhoto>!
    var indexMidImage: Int = 0
    var leftImageView = UIImageView()
    var midImageView = UIImageView()
    var rightImageView = UIImageView()
    var swipeToRight = UIViewPropertyAnimator()
    var swipeToLeft = UIViewPropertyAnimator()
    let optionsNuke = ImageLoadingOptions(
      placeholder: UIImage(systemName: "photo"),
      transition: .fadeIn(duration: 0.25)
    )
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground
        self.view = view
        let gestPan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        view.addGestureRecognizer(gestPan)
        setupImageViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sizeMid = selectSizePhoto(of: userPhotos[indexMidImage].sizes)
        if let url = URL(string: sizeMid.urlString) {
            Nuke.loadImage(with: url, options: optionsNuke, into: midImageView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.subviews.forEach{ if $0 != midImageView{ $0.isHidden = true } }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.subviews.forEach{ $0.isHidden = false }
    }
    
    func selectSizePhoto(of sizeList: List<RealmSize>) -> RealmSize {
        let sizes = sizeList.map { $0.type }
        
        if sizes.contains("w") {
            let myIndex = Int(sizeList.firstIndex { $0.type == "w" }!)
            return sizeList[myIndex]
        } else if sizes.contains("z") {
            let myIndex = Int(sizeList.firstIndex { $0.type == "z" }!)
            return sizeList[myIndex]
        } else if sizes.contains("y") {
            let myIndex = Int(sizeList.firstIndex { $0.type == "y" }!)
            return sizeList[myIndex]
        } else if sizes.contains("x") {
            let myIndex = Int(sizeList.firstIndex { $0.type == "x" }!)
            return sizeList[myIndex]
        }
        
        return sizeList.last!
    }
    
    func setupImageViews() {
        leftImageView.contentMode = .scaleAspectFit
        midImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit
        
        view.addSubview(leftImageView)
        view.addSubview(midImageView)
        view.addSubview(rightImageView)
        
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        midImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        midImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        midImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        midImageView.heightAnchor.constraint(equalTo: midImageView.widthAnchor, multiplier: 4/3).isActive = true
        midImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        leftImageView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        leftImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        leftImageView.heightAnchor.constraint(equalTo: midImageView.heightAnchor).isActive = true
        leftImageView.widthAnchor.constraint(equalTo: midImageView.widthAnchor).isActive = true
        
        rightImageView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        rightImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rightImageView.heightAnchor.constraint(equalTo: midImageView.heightAnchor).isActive = true
        rightImageView.widthAnchor.constraint(equalTo: midImageView.widthAnchor).isActive = true
        
        midImageView.clipsToBounds = true
        rightImageView.clipsToBounds = true
        leftImageView.clipsToBounds = true
    }
    
    func setImages() {
        var indexPhotoLeft = indexMidImage - 1
        if indexPhotoLeft < 0 { indexPhotoLeft = userPhotos.count - 1 }
        
        var indexPhotoRight = indexMidImage + 1
        if indexPhotoRight > userPhotos.count - 1 { indexPhotoRight = 0 }
        
        let sizeLeft = selectSizePhoto(of: userPhotos[indexPhotoLeft].sizes)
        if let url = URL(string: sizeLeft.urlString) {
            Nuke.loadImage(with: url, options: optionsNuke, into: leftImageView)
        }
        let sizeMid = selectSizePhoto(of: userPhotos[indexMidImage].sizes)
        if let url = URL(string: sizeMid.urlString) {
            Nuke.loadImage(with: url, options: optionsNuke, into: midImageView)
        }
        let sizeRight = selectSizePhoto(of: userPhotos[indexPhotoRight].sizes)
        if let url = URL(string: sizeRight.urlString) {
            Nuke.loadImage(with: url, options: optionsNuke, into: rightImageView)
        }
    }
    
    func scaleAnimate(){
        setImages()
        let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.midImageView.transform = scale
        self.rightImageView.transform = scale
        self.leftImageView.transform = scale
        
        
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [],
            animations: { [unowned self] in
                self.midImageView.transform = .identity
                self.rightImageView.transform = .identity
                self.leftImageView.transform = .identity
            })
    }
    
    @objc func pan(_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            
            swipeToRight = UIViewPropertyAnimator(
                duration: 0.25,
                curve: .easeIn,
                animations: {
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 0,
                        options: [],
                        animations: { [unowned self] in
                            let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            let translation = CGAffineTransform(translationX: self.view.bounds.maxX, y: 0)
                            let transform = scale.concatenating(translation)
                            self.midImageView.transform = transform
                            self.rightImageView.transform = transform
                            self.leftImageView.transform = transform
                        }, completion: { [unowned self] _ in
                            self.indexMidImage -= 1
                            if self.indexMidImage < 0 {
                                self.indexMidImage = self.userPhotos.count - 1
                            }
                            self.scaleAnimate()
                        })
                })
            
            swipeToLeft = UIViewPropertyAnimator(
                duration: 0.25,
                curve: .easeIn,
                animations: {
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 0,
                        options: [],
                        animations: { [unowned self] in
                            let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            let translation = CGAffineTransform(translationX: -self.view.bounds.maxX, y: 0)
                            let transform = scale.concatenating(translation)
                            self.midImageView.transform = transform
                            self.rightImageView.transform = transform
                            self.leftImageView.transform = transform
                        }, completion: { [unowned self] _ in
                            self.indexMidImage += 1
                            if self.indexMidImage > self.userPhotos.count - 1 {
                                self.indexMidImage = 0
                            }
                            self.scaleAnimate()
                        })
                })
            
        case .changed:
            let translationX = recognizer.translation(in: self.view).x
            let translationY = recognizer.translation(in: self.view).y
            if translationY < -100 {self.navigationController?.popViewController(animated: true)}
            if translationX > 0 { swipeToRight.fractionComplete = abs(translationX)/200 }
            else { swipeToLeft.fractionComplete = abs(translationX)/200 }
            
        case .ended:
            swipeToRight.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            swipeToLeft.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            return
        }
    }
}
