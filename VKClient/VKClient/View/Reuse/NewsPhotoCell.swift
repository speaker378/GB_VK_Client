//
//  NewsPhotoCell.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit

class NewsPhotoCell: UITableViewCell {
    
    let image = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        image.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(image)
        
        contentView.backgroundColor = .systemOrange
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 100),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),

        ])
        
    }
    
}
