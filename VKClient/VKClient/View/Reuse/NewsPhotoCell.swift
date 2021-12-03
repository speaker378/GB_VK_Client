//
//  NewsPhotoCell.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit
import Nuke

class NewsPhotoCell: UITableViewCell {
    
    let image = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        image.image = nil
    }
    
    func setupViews() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemBackground
        image.isOpaque = true
        
        contentView.addSubview(image)
        
        contentView.backgroundColor = .systemBackground
        contentView.isOpaque = true
        
        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 300),
        ])
        
    }
    
    func configure(_ photoSizes: [Size], sizesByPriority: [SizeType]) {
        let options = ImageLoadingOptions(
            placeholder: UIImage(systemName: "photo"),
            transition: .fadeIn(duration: 0.25)
        )
        let urlString = Photo.findUrlInPhotoSizes(sizes: photoSizes, sizesByPriority: sizesByPriority).src
        let url = URL(string: urlString!)
        
        Nuke.loadImage(with: url, options: options, into: self.image)
    }
    
}
