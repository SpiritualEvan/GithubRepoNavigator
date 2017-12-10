//
//  RepositoryInfoCell.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 10..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import UIKit

class RepositoryInfoCell: UITableViewCell {
    
    static let reuseIdentifier = "RepositoryInfoCellIdentifier"
    
    var avatarView:UIImageView!
    var nameField:UILabel!
    var borderView:UIView!
    
    override var reuseIdentifier: String? {
        return RepositoryInfoCell.reuseIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    private func initialize() {
        
        borderView = UIView(frame: .zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.borderWidth = 0.1
        contentView.addSubview(borderView)
        
        avatarView = UIImageView(frame: .zero)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.borderColor = UIColor.lightGray.cgColor
        avatarView.layer.borderWidth = 0.1
        borderView.addSubview(avatarView)
        
        nameField = UILabel(frame: .zero)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.sizeToFit()
        borderView.addSubview(nameField)

        NSLayoutConstraint.activate([
            
            avatarView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10.0),
            avatarView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 10.0),
            avatarView.widthAnchor.constraint(equalToConstant: 40.0),
            avatarView.heightAnchor.constraint(equalToConstant: 40.0),
            avatarView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -10.0),
            
            nameField.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            nameField.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10.0),
            nameField.trailingAnchor.constraint(greaterThanOrEqualTo: borderView.trailingAnchor, constant: 10.0),
            
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            ])
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
