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
    func testModelValidationWithPageLoading() {
        
        let expect = expectation(description: "testNextFetchObserver")
        
        RepositoryListFetcher.shared.nextPageObserver(reset:true)
            .subscribe(onNext: { (results) in
                XCTAssertGreaterThan(results.count, 0)
                for repositoryInfo in results {
                    XCTAssertNotNil(repositoryInfo.owner)
                }
                expect.fulfill()
                
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            }, onCompleted:nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    func testResetPageLoading() {
        
        let expect = expectation(description: "testNextFetchObserver")
        var firstRepositoryInfo:RepositoryInfo!
        
        RepositoryListFetcher.shared.nextPageObserver(reset:true)
            .subscribe(onNext: { (results) in
                firstRepositoryInfo = results[0]
                
                RepositoryListFetcher.shared.nextPageObserver(reset:true)
                    .subscribe(onNext: { (results) in
                        
                        XCTAssertEqual(firstRepositoryInfo.owner, results[0].owner)
                        
                        expect.fulfill()
                    }, onError: nil, onCompleted:nil, onDisposed: nil).disposed(by: self.disposeBag)
                
            }, onError: nil, onCompleted:nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
        }
        
    }
    func testNextPageLoading() {
        
        let expect = expectation(description: "testNextFetchObserver")
        var firstRepositoryInfo:RepositoryInfo!
        
        RepositoryListFetcher.shared.nextPageObserver(reset:true)
            .subscribe(onNext: { (results) in
                firstRepositoryInfo = results[0]
                
                RepositoryListFetcher.shared.nextPageObserver(reset:false)
                    .subscribe(onNext: { (results) in
                        
                        // first object of next page must be differ from first object of initial page
                        XCTAssertNotEqual(firstRepositoryInfo.owner, results[0].owner)
                        
                        expect.fulfill()
                    }, onError: nil, onCompleted:nil, onDisposed: nil).disposed(by: self.disposeBag)
                
            }, onError: nil, onCompleted:nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
        }
        
    }
}
