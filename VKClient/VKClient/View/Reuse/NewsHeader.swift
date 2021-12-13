//
//  NewsHeader.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit

class NewsHeader: UITableViewHeaderFooterView {
    
    let creatorName = UILabel()
    let creatorAvatar = UIImageView()
    let dateLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        creatorAvatar.translatesAutoresizingMaskIntoConstraints = false
        creatorName.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(creatorName)
        contentView.addSubview(creatorAvatar)
        contentView.addSubview(dateLabel)
        
        creatorAvatar.layer.cornerRadius = 25
        creatorAvatar.layer.masksToBounds = true
        creatorAvatar.contentMode = .scaleToFill
        creatorAvatar.backgroundColor = .systemBackground
        creatorAvatar.isOpaque = true
        
        creatorName.font = UIFont.systemFont(ofSize: 22)
        creatorName.backgroundColor = .systemBackground
        creatorName.isOpaque = true
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.backgroundColor = .systemBackground
        dateLabel.isOpaque = true
        
        contentView.backgroundColor = .systemBackground
        contentView.isOpaque = true
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        NSLayoutConstraint.activate([
            
            creatorAvatar.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            creatorAvatar.widthAnchor.constraint(equalToConstant: 50),
            creatorAvatar.heightAnchor.constraint(equalToConstant: 50),
            creatorAvatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            creatorName.heightAnchor.constraint(equalToConstant: 30),
            creatorName.leadingAnchor.constraint(equalTo: creatorAvatar.trailingAnchor, constant: 8),
            creatorName.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            creatorName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            
            dateLabel.heightAnchor.constraint(equalToConstant: 14),
            dateLabel.leadingAnchor.constraint(equalTo: creatorAvatar.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
    }
    
}
