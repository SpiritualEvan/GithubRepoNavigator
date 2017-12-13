//
//  Repository.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 12..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import Foundation

struct RepositoryOwner : Codable {
    var login:String!
    var avatar_url:URL!
}

struct Repository : Codable {
    var owner:RepositoryOwner!
}
