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
        communityNameLabel.textColor = UIColor.black
        communityNameLabel.font = UIFont.systemFont(ofSize: 20)
        membersLabel.textColor = UIColor.gray
        membersLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
    func configure(community: Community) {
        communityImageView.image = community.avatar
        communityNameLabel.text = community.name
        membersLabel.text = String(community.members) + " участников"
    }
    
}
