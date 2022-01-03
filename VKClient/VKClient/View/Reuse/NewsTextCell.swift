//
//  NewsTextCell.swift
//  VKClient
//
//  Created by Сергей Черных on 10.11.2021.
//

import UIKit

protocol NewsTextCellDelegate: AnyObject {
    func contentDidChange (cell: NewsTextCell)
}

class NewsTextCell: UITableViewCell {
    
    let newsText = UILabel()
    let button = UIButton()
    let textFont = UIFont.system(size: 18)
    var buttonHeighToConstraint = NSLayoutConstraint()
    var fullText = true
    weak var delegate: NewsTextCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        newsText.text = nil
    }
    
    func setupViews() {
        newsText.translatesAutoresizingMaskIntoConstraints = false
        newsText.backgroundColor = .systemBackground
        newsText.isOpaque = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(button)
        contentView.addSubview(newsText)
        
        newsText.font = textFont
        newsText.numberOfLines = 0
        
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(press), for: .touchUpInside)
        
        contentView.backgroundColor = .systemBackground
        contentView.isOpaque = true
        
        NSLayoutConstraint.activate([
            
            newsText.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsText.bottomAnchor.constraint(equalTo: button.topAnchor),
            
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        
        buttonHeighToConstraint = button.heightAnchor.constraint(equalToConstant: CGFloat(0))
        buttonHeighToConstraint.isActive = true
    }
    
    @objc func press() {
        fullText.toggle()
        button.setTitle(nameForButton(), for: .normal)
        delegate.contentDidChange(cell: self)
    }
    
    private func nameForButton() -> String {
        return (fullText ? "показать меньше букав" : "показать больше букав")
    }
    
    func configure(newsText: String) {
        self.newsText.text = newsText
        if newsText.getTextHeight(width: contentView.frame.width, font: textFont) >= 200 {
            buttonHeighToConstraint.constant = CGFloat(20)
            fullText = false
            button.setTitle(nameForButton(), for: .normal)
            button.isHidden = false
        } else {
            buttonHeighToConstraint.constant = CGFloat(0)
            button.isHidden = true
            fullText = true
        }
    }
    
}
