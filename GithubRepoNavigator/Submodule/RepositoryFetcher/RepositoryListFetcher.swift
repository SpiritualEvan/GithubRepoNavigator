//
//  RepositoryListFetcher.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 10..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import UIKit
import RxSwift

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
    
    func beginFetch() -> Observable<[RepositoryInfo]> {
        
        return Observable<[RepositoryInfo]>.create{ (observer) -> Disposable in
            
            let url = URL(string: "https://api.github.com/repositories")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard nil == error else {
                    observer.onError(error!)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    observer.onError(RepositoryListFetcherError.noResponseReturnedFromServer)
                    return
                }
                guard 200 == response.statusCode else {
                    observer.onError(RepositoryListFetcherError.serverResponseError(code: response.statusCode))
                    return
                }
                guard let data = data else {
                    observer.onError(RepositoryListFetcherError.noDataReturnedFromServer)
                    return
                }
                observer.onNext([])
                
            }
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
    }
}
