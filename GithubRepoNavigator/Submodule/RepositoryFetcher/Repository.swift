//
//  Repository.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 12..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import Foundation

struct RepositoryOwner : Codable {
    var loginID:String
    var avatarURL:URL
    
    enum CodingKeys:String, CodingKey {
        case loginID = "login"
        case avatarURL = "avatar_url"
    }
}

struct Repository : Codable {
    var owner:RepositoryOwner!
}
