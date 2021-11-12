//
//  NewsTextCell.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit

class NewsTextCell: UITableViewCell {
    
    let newsText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        newsText.text = nil
    }
    
    func configureContents() {
        newsText.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(newsText)
        
        newsText.font = UIFont.systemFont(ofSize: 18)
        newsText.numberOfLines = 0

        contentView.backgroundColor = .systemOrange
        
        NSLayoutConstraint.activate([
            
            newsText.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            newsText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newsText.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            newsText.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
    }
    
}
