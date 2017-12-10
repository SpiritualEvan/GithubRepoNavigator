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
    
    override var reuseIdentifier: String? {
        return RepositoryInfoCell.reuseIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    private func initialize() {
        
        separatorInset = UIEdgeInsetsMake(0, 0, 10, 0)
        
        avatarView = UIImageView(frame: .zero)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarView)
        
        nameField = UILabel(frame: .zero)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameField)

        NSLayoutConstraint.activate([
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            avatarView.widthAnchor.constraint(equalToConstant: 40.0),
            avatarView.heightAnchor.constraint(equalToConstant: 40.0),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10.0),
            
            nameField.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameField.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10.0),
            nameField.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: 10.0)
            ])
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
