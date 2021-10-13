//
//  CommunityCell.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit

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
        if let url = URL(string: community.avatarUrlString) {
            communityImageView.loadImage(from: url)
        }
        communityNameLabel.text = community.name
    }
    
}
