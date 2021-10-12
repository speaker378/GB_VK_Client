//
//  FriendTableViewCell.swift
//  VKClient
//
//  Created by Сергей Черных on 30.08.2021.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var containerForImageUIView: UIView!
    @IBOutlet weak var avatarUIImageView: UIImageView!
    @IBOutlet weak var nameUILabel: UILabel!
    @IBOutlet weak var networkStatusUILabel: UILabel!
    @IBOutlet weak var networkStatusUIImage: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    @objc func animate(_ sender: UITapGestureRecognizer) {
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.transform = scale
        self.alpha = 0.5
        
        UIImageView.animate(withDuration: 0.75,
                            delay: 0,
                            usingSpringWithDamping: 0.5,
                            initialSpringVelocity: 0,
                            options: [.curveEaseInOut],
                            animations: {
                                self.transform = .identity
                                self.alpha = 1
                            })
    }
    
    private func setupViews() {
        avatarUIImageView.layer.borderWidth = 1
        avatarUIImageView.layer.borderColor = UIColor.black.cgColor
        avatarUIImageView.layer.cornerRadius = avatarUIImageView.frame.height / 2
        avatarUIImageView.clipsToBounds = true
        
        nameUILabel.font = UIFont.systemFont(ofSize: 22)
        
        containerForImageUIView.layer.shadowOpacity = 0.6
        containerForImageUIView.layer.cornerRadius = containerForImageUIView.frame.height / 2
        containerForImageUIView.clipsToBounds = true
        containerForImageUIView.layer.masksToBounds = false
        
        networkStatusUIImage.image = UIImage(systemName: "circle.fill")
        
        networkStatusUILabel.font = UIFont.systemFont(ofSize: 10)

        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.animate(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.avatarUIImageView.addGestureRecognizer(singleTap)
        self.avatarUIImageView.isUserInteractionEnabled = true
        self.selectionStyle = .none
    }
    
    func configure(friend: Friend) {
        if let url = URL(string: friend.avatarURL) {
            avatarUIImageView.loadImage(from: url)
        }
        nameUILabel.text = friend.firstName + " " + friend.lastName
        
        switch friend.networkStatus {
        case 1:
            networkStatusUILabel.text = "Online"
            networkStatusUIImage.tintColor = .systemGreen
        default:
            networkStatusUILabel.text = "Offline"
            networkStatusUIImage.tintColor = .systemGray
        }
    }

}
