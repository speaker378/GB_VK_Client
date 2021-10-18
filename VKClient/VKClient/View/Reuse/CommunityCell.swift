//
//  CommunityCell.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit
import Nuke

class CommunityCell: UITableViewCell {
    @IBOutlet weak var communityImageView: UIImageView!
    @IBOutlet weak var communityNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
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
    
    private func setupViews() {
        communityNameLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    func configure(community: Community) {
        let options = ImageLoadingOptions(
          placeholder: UIImage(systemName: "photo"),
          transition: .fadeIn(duration: 0.25)
        )
        if let url = URL(string: community.avatarUrlString) {
            Nuke.loadImage(with: url, options: options, into: communityImageView)
        }
        communityNameLabel.text = community.name
    }
    
}
