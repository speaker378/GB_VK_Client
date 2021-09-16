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
    @IBOutlet weak var membersLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(community: Community) {
        communityImageView.image = community.avatar
        communityNameLabel.text = community.name
        communityNameLabel.textColor = UIColor.black
        communityNameLabel.font = UIFont.systemFont(ofSize: 20)
        membersLabel.text = String(community.members) + " участников"
        membersLabel.textColor = UIColor.gray
        membersLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
}
