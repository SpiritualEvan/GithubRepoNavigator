//
//  RepositoryModel.swift
//  GithubRepoNavigator
//
//  Created by Won Cheul Seok on 2017. 12. 12..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct RepositoryModel {
    let provider: MoyaProvider<GithubRepoEndpoint>
    
    private let disposeBag = DisposeBag()
    
    func repositoryListObserver() -> Observable<[RepositoryOwner]> {
        
        return Observable<[RepositoryOwner]>.create{ (observer) -> Disposable in
            
            self.provider.rx
                .request(GithubRepoEndpoint(headers: nil))
                .debug()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { response in
                    
                    let decoder = JSONDecoder()
                    do {
                        let repositories = try decoder.decode([Repository].self, from: response.data).flatMap { $0.owner }
                        observer.onNext(repositories)
                    }catch {
                        observer.onError(error)
                        return
                    }
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create() {}
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
        
    }
}
