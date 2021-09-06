//
//  LikeControl.swift
//  VKClient
//
//  Created by Сергей Черных on 06.09.2021.
//

import UIKit

class Like: UIControl {
    
    var likes: UInt = 0 {
        didSet {
            numberOfLikes.text = String(likes)
        }
    }
    var stateButton = false
    let button = UIButton(type: .system)
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
        
        button.tintColor = .white
        button.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        button.frame = self.bounds
        button.addTarget(self, action: #selector(likePressed(_:)), for: .touchUpInside)
        
        numberOfLikes.frame.size.height = button.bounds.size.height * CGFloat(0.6)
        numberOfLikes.frame.size.width = button.bounds.size.width * CGFloat(0.6)
        numberOfLikes.center.x = button.center.x
        numberOfLikes.center.y = button.center.y * CGFloat(0.9)
        numberOfLikes.text = String(likes)
        numberOfLikes.font = UIFont.boldSystemFont(ofSize: numberOfLikes.frame.size.height)
        numberOfLikes.textColor = .systemRed
        numberOfLikes.textAlignment = .center
        
        self.addSubview(button)
        self.addSubview(numberOfLikes)
    }
    
    @objc private func likePressed(_ sender: UIButton) {
        if stateButton == false {
            sender.tintColor = .systemRed
            likes += 1
            numberOfLikes.textColor = .white
            stateButton = true
        } else {
            sender.tintColor = .white
            likes -= 1
            numberOfLikes.textColor = .systemRed
            stateButton = false
        }
    }
    
}
