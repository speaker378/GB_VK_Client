//
//  LikeControl.swift
//  VKClient
//
//  Created by Сергей Черных on 06.09.2021.
//

import UIKit

class Like: UIControl {
    
    var likes: Int = 0 {
        didSet {
            numberOfLikes.text = String(likes)
        }
    }
    var stateButton = false
    
    let stackView = UIStackView()
    let image = UIImageView()
    let numberOfLikes  = UILabel()
    
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
        
        image.tintColor = .white
        image.image = UIImage(systemName: "suit.heart.fill")
        
        numberOfLikes.font = UIFont.boldSystemFont(ofSize: 20)
        numberOfLikes.textColor = .systemRed
        numberOfLikes.textAlignment = .left
        
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
                                self.image.tintColor = .red
                              })
            UIView.transition(with: numberOfLikes,
                              duration: 0.33,
                              options: .transitionFlipFromTop,
                              animations: { [unowned self] in
                                self.numberOfLikes.textColor = .white
                              })
            stateButton.toggle()
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
                                self.numberOfLikes.textColor = .red
                              })
            stateButton.toggle()
        }
    }
    
}
