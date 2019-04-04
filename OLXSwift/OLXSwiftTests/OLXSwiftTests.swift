//
//  OLXSwiftTests.swift
//  OLXSwiftTests
//
//  Created by Bruno1 on 04/04/2019.
//

import XCTest
@testable import OLXSwift

class OLXSwiftTests: XCTestCase {

    private var videosRequest: Request.Videos!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.videosRequest = Request.Videos(page: 1)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.videosRequest = nil
    }

    func testRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertNotNil(NetworkManagerNew().response(with: self.videosRequest, onSuccess: { (response) in}, onError: { (error) in}) {})
    }

    func testRequestStorage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertNotNil(NetworkManagerNew().response(with: self.videosRequest, onSuccess: { (response)
            in
            Storage.store(response, to: .documents, as: File.resources)
        }, onError: { (error) in}) {})
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
