//
//  NewsCell.swift
//  VKClient
//
//  Created by Сергей Черных on 08.09.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var creatorAvatarContainer: UIView!
    @IBOutlet weak var creatorAvatar: UIImageView!
    @IBOutlet weak var creatorName: UILabel!
    
    @IBOutlet weak var textNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var repost: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var like: UILabel!
    

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(news: News) {
        
        creatorAvatar.image = news.creator.avatar
        creatorAvatar.layer.borderWidth = 1
        creatorAvatar.layer.borderColor = UIColor.black.cgColor
        creatorAvatar.layer.cornerRadius = creatorAvatar.frame.height / 2
        creatorAvatar.clipsToBounds = true
        
        creatorAvatarContainer.layer.shadowOpacity = 0.6
        creatorAvatarContainer.layer.cornerRadius = creatorAvatarContainer.frame.height / 2
        creatorAvatarContainer.clipsToBounds = true
        creatorAvatarContainer.layer.masksToBounds = false
        
        creatorName.text = news.creator.name
        creatorName.textColor = UIColor.black
        creatorName.font = UIFont.systemFont(ofSize: 22)
        
        
        textNews.text = news.text
        textNews.textColor = UIColor.black
        textNews.font = UIFont.systemFont(ofSize: 22)
        
        imageNews.image = news.images[0]
    }
    
}