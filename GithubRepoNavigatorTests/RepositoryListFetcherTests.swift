//
//  RepositoryListFetcherTests.swift
//  GithubRepoNavigatorTests
//
//  Created by Won Cheul Seok on 2017. 12. 10..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import XCTest
import RxSwift
@testable import GithubRepoNavigator
class RepositoryListFetcherTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNewFetchObserver() {
        let expect = expectation(description: "testBeginFetchExpect")
        RepositoryListFetcher.shared.newFetchObserver()
            .subscribe(onNext: { (results) in
                XCTAssertGreaterThan(results.count, 0)
                for repositoryInfo in results {
                    XCTAssertNotNil(repositoryInfo.owner)
                }
                expect.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            }, onCompleted:nil, onDisposed: nil).disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    func testNextFetchObserver() {
        let expect = expectation(description: "testNextFetchObserver")
        
        RepositoryListFetcher.shared.newFetchObserver()
            .subscribe(onNext: { (results) in
                
                // fetch next page after first fetch
                RepositoryListFetcher.shared.nextFetchObserver()
                    .subscribe(onNext: { (results) in
                        XCTAssertGreaterThan(results.count, 0)
                        for repositoryInfo in results {
                            XCTAssertNotNil(repositoryInfo.owner)
                        }
                        expect.fulfill()
                    }, onError: { (error) in
                        XCTFail(error.localizedDescription)
                    }, onCompleted:nil, onDisposed: nil).disposed(by: self.disposeBag)

                
            }, onError: nil, onCompleted:nil, onDisposed: nil).disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
        }
        
    }
    
}
