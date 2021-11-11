//
//  GroupCell.swift
//  VKClient
//
//  Created by Сергей Черных on 25.08.2021.
//

import UIKit
import Nuke

class GroupCell: UITableViewCell {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
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
        groupNameLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    func configure(group: RealmGroup) {
        let options = ImageLoadingOptions(
          placeholder: UIImage(systemName: "photo"),
          transition: .fadeIn(duration: 0.25)
        )
        if let url = URL(string: group.avatarUrlString) {
            Nuke.loadImage(with: url, options: options, into: groupImageView)
        }
        groupNameLabel.text = group.name
    }
    
    func configure(group: Group) {
        let options = ImageLoadingOptions(
          placeholder: UIImage(systemName: "photo"),
          transition: .fadeIn(duration: 0.25)
        )
        if let url = URL(string: group.avatarUrlString) {
            Nuke.loadImage(with: url, options: options, into: groupImageView)
        }
        groupNameLabel.text = group.name
    }
    
}
