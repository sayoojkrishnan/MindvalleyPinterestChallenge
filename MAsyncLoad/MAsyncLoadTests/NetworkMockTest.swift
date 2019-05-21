//
//  NetworkMockTest.swift
//  MAsyncLoadTests
//
//  Created by Sayooj on 21/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import XCTest
@testable import MAsyncLoad
class NetworkMockTest: XCTestCase {

    var client : NetworkClient!
    var data : Data?
    override func setUp() {
        
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "pins", ofType: "json")
        data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let url = URL(string: "http://pastebin.com/raw/wgkJgazE?page=1")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let session = URLSessionMock(data: data, response: urlResponse, error: nil)
        client = NetworkClient(session: session)
        
        
    }

    override func tearDown() {
        data = nil
        client = nil
    }
    
    
    func testNetworkClientWithPromise(){
        let promise = expectation(description: "Responsedata similar as data")
        
        var responseData : Data?
        var responseError: Error?
        let url = URL(string: "http://pasdkdngfdftebin.com/raw/wgkJgazE?page=1")
        client.fetch(url: url!) { (responseResult) in
            switch responseResult {
            case .Success(let d) :
                if d != nil {
                    promise.fulfill()
                    responseData = d
                }
               
            case .Error(let e) :
                print("Error")
                responseError = e
            }
        }
        
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(responseData, data)
    }
    
   

   

}
