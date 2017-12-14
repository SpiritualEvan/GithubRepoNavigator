//
//  RepositoryModelTests.swift
//  GithubRepoNavigatorTests
//
//  Created by Won Cheul Seok on 2017. 12. 13..
//  Copyright © 2017년 Evan Seok. All rights reserved.
//

import XCTest
import Moya
import RxSwift
@testable import GithubRepoNavigator

class RepositoryModelTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchRepositories() {
        let expect = expectation(description: "testFetchRepositories expect")
        
        let model = RepositoryModel(provider: MoyaProvider<GithubRepoEndpoint>())
        model.repositoryListObserver()
            .subscribe(onNext: { (repositories) in
                XCTAssertGreaterThan(repositories.count, 0)
                expect.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
                expect.fulfill()
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 10.0) { (error) in
            guard nil == error else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
