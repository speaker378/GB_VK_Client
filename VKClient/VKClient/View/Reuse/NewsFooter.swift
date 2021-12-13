//
//  NewsFooter.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit

class NewsFooter: UITableViewHeaderFooterView {
    
    let likesImage = UIImageView()
    let commentsImage = UIImageView()
    let repostsImage = UIImageView()
    let viewsImage = UIImageView()
    
    let likesLabel = UILabel()
    let commentsLabel = UILabel()
    let repostsLabel = UILabel()
    let viewsLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        likesImage.translatesAutoresizingMaskIntoConstraints = false
        commentsImage.translatesAutoresizingMaskIntoConstraints = false
        repostsImage.translatesAutoresizingMaskIntoConstraints = false
        viewsImage.translatesAutoresizingMaskIntoConstraints = false
        
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        repostsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(likesImage)
        contentView.addSubview(commentsImage)
        contentView.addSubview(repostsImage)
        contentView.addSubview(viewsImage)
        
        contentView.addSubview(likesLabel)
        contentView.addSubview(commentsLabel)
        contentView.addSubview(repostsLabel)
        contentView.addSubview(viewsLabel)
        
        likesImage.image =  UIImage(systemName: "heart")
        commentsImage.image =  UIImage(systemName: "message")
        repostsImage.image =  UIImage(systemName: "arrowshape.turn.up.right")
        viewsImage.image =  UIImage(systemName: "eye")
        
        likesLabel.font = UIFont.systemFont(ofSize: 16)
        commentsLabel.font = UIFont.systemFont(ofSize: 16)
        repostsLabel.font = UIFont.systemFont(ofSize: 16)
        viewsLabel.font = UIFont.systemFont(ofSize: 16)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        contentView.backgroundColor = .systemBackground
        contentView.isOpaque = true
        contentView.subviews.forEach {
            $0.backgroundColor = .systemBackground
            $0.isOpaque = true
        }
        
        NSLayoutConstraint.activate([
            
            likesImage.heightAnchor.constraint(equalToConstant: 20),
            likesImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likesImage.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
            likesLabel.heightAnchor.constraint(equalToConstant: 20),
            likesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likesImage.trailingAnchor, constant: 2),
            
            commentsImage.heightAnchor.constraint(equalToConstant: 20),
            commentsImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            commentsImage.leadingAnchor.constraint(equalTo: likesImage.trailingAnchor, constant: 60),
            
            commentsLabel.heightAnchor.constraint(equalToConstant: 20),
            commentsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsImage.trailingAnchor, constant: 2),
            
            repostsImage.heightAnchor.constraint(equalToConstant: 20),
            repostsImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            repostsImage.leadingAnchor.constraint(equalTo: commentsImage.trailingAnchor, constant: 60),
            
            repostsLabel.heightAnchor.constraint(equalToConstant: 20),
            repostsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            repostsLabel.leadingAnchor.constraint(equalTo: repostsImage.trailingAnchor, constant: 2),
            
            viewsImage.heightAnchor.constraint(equalToConstant: 20),
            viewsImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewsImage.trailingAnchor.constraint(equalTo: viewsLabel.leadingAnchor, constant: 2),
            
            viewsLabel.heightAnchor.constraint(equalToConstant: 20),
            viewsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
    }
    
}
