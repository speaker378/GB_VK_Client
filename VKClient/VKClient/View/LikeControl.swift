//
//  LikeControl.swift
//  VKClient
//
//  Created by Сергей Черных on 06.09.2021.
//

import UIKit

class Like: UIControl {
    
    var ownerID = 0
    var itemID = 0
    var likes = 0 {
        didSet {
            numberOfLikes.text = String(likes)
        }
    }
    var stateButton = false { didSet {
        switch stateButton {
            case false:
            numberOfLikes.textColor = .white
            image.tintColor = .white
            case true:
            numberOfLikes.textColor = .systemRed
            image.tintColor = .systemRed
        }
    } }
    
    let stackView = UIStackView()
    let image = UIImageView()
    let numberOfLikes  = UILabel()
    let networkService: NetworkServiceProxy = NetworkServiceProxy(networkService: NetworkService())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .none
        
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        
        image.image = UIImage(systemName: "suit.heart.fill")
        image.tintColor = .white
        
        numberOfLikes.font = UIFont.system(size: 20)
        numberOfLikes.textAlignment = .right
        numberOfLikes.textColor = .white
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(numberOfLikes)
        stackView.addArrangedSubview(image)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.likePressed(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(singleTap)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func likePressed(_ sender: UITapGestureRecognizer) {
        if stateButton == false {
            likes += 1
            UIView.transition(with: image,
                              duration: 0.59,
                              options: .transitionFlipFromBottom,
                              animations: { [unowned self] in
                self.image.tintColor = .systemRed
                              })
            UIView.transition(with: numberOfLikes,
                              duration: 0.33,
                              options: .transitionFlipFromTop,
                              animations: { [unowned self] in
                self.numberOfLikes.textColor = .systemRed
                              })
            stateButton.toggle()
            networkService.likePhoto(ownerID: ownerID, itemID: itemID, action: .add)
        } else {
            likes -= 1
            UIView.transition(with: numberOfLikes,
                              duration: 0.59,
                              options: .transitionFlipFromTop,
                              animations: { [unowned self] in
                                self.image.tintColor = .white
                              })
            UIView.transition(with: image,
                              duration: 0.33,
                              options: .transitionFlipFromBottom,
                              animations: { [unowned self] in
                self.numberOfLikes.textColor = .white
                              })
            stateButton.toggle()
            networkService.likePhoto(ownerID: ownerID, itemID: itemID, action: .delete)
        }
    }
    
}
