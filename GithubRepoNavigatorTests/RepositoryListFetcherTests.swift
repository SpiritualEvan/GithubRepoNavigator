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
    
    func testBeginFetch() {
        let expect = expectation(description: "a")
        RepositoryListFetcher.shared.beginFetch()
            .subscribe(onNext: { (results) in
                XCTAssertGreaterThan(results.count, 0)
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            }, onCompleted: {
                expect.fulfill()
            }, onDisposed: nil).disposed(by: disposeBag)
        self.waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    
    
}
