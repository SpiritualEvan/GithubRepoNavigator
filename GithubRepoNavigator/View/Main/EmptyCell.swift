//
//  EmptyCell.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 10..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {

    static let reuseIdentifier = "EmptyCellIdentifier"

    override var reuseIdentifier: String? {
        return EmptyCell.reuseIdentifier
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
        textLabel!.text = "Empty"
        textLabel!.textAlignment = .center
    }
}
