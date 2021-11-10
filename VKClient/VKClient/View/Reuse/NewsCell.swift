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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        creatorAvatar.layer.borderWidth = 1
        creatorAvatar.layer.borderColor = UIColor.black.cgColor
        creatorAvatar.layer.cornerRadius = creatorAvatar.frame.height / 2
        creatorAvatar.clipsToBounds = true
        
        creatorAvatarContainer.layer.shadowOpacity = 0.6
        creatorAvatarContainer.layer.cornerRadius = creatorAvatarContainer.frame.height / 2
        creatorAvatarContainer.clipsToBounds = true
        creatorAvatarContainer.layer.masksToBounds = false
        
        creatorName.font = UIFont.systemFont(ofSize: 22)
        
        textNews.font = UIFont.systemFont(ofSize: 22)
    }
    
    func configure(news: NewsPublication) {
//        creatorAvatar.image = news.creator.avatar
//        creatorName.text = news.creator.name
        textNews.text = news.text
//        imageNews.image = news.images[0]
    }
    
}
