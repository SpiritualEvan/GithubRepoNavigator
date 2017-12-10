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

enum RepositoryListFetcherError:Error {
    case noResponseReturnedFromServer
    case serverResponseError(code:Int)
    case noDataReturnedFromServer
}

final class RepositoryListFetcher {
    
    static let shared = RepositoryListFetcher()
    
    private var since:Int = 0
    
    func beginFetch(completion:@escaping (_ results:[RepositoryInfo]?, _ error:Error?) -> Void) {
        
        let url = URL(string: "https://api.github.com/repositories")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard nil == error else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(nil, RepositoryListFetcherError.noResponseReturnedFromServer)
                }
                return
            }
            guard 200 == response.statusCode else {
                DispatchQueue.main.async {
                    completion(nil, RepositoryListFetcherError.serverResponseError(code: response.statusCode))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, RepositoryListFetcherError.noDataReturnedFromServer)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            
        }.resume()
    }
}
