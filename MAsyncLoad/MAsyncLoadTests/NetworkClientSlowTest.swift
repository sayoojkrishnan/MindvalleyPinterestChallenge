//
//  NetworkClientTest.swift
//  MAsyncLoadTests
//
//  Created by Sayooj on 20/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import XCTest

@testable import MAsyncLoad
class NetworkClientTest : XCTestCase {
    
    
    func testSuccessResponse(){
       let url = URL(string: "https://www.google.com/")
        
       let promise = expectation(description: "Status code: 200")
        
        NetworkClient.shared.fetch(url: url!) { (result) in
            switch result {
            case .Success(_) :
                promise.fulfill()
            case .Error(let error) :
                XCTFail("Fail to load \(error.localizedDescription)")
            }
        }
        
        wait(for: [promise], timeout: 10)
    }
}
