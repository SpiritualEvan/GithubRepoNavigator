//
//  RepositoryListFetcher.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 10..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import UIKit

struct RepositoryInfo {
    var avatar:URL?
    var owner:String!
}

final class RepositoryListFetcher {
    
    static let shared = RepositoryListFetcher()
    
    func beginFetch(completion:(_ results:[RepositoryInfo]?, _ error:Error?) -> Void) {
        
    }
}
