//
//  PinBoardProviderTest.swift
//  MindvalleyPinterestChallengeTests
//
//  Created by Sayooj on 21/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import XCTest
@testable import MindvalleyPinterestChallenge
class PinBoardProviderTest: XCTestCase {

    var pins : [Pin]!
    var provider : PinBoardDataProvider!
    override func setUp() {
        provider = PinBoardDataProvider()
        pins = [Pin]()
    }

    override func tearDown() {
       provider = nil
       pins = []
    }
    
    
    func testDataProviderLoadAndDeocde(){
        let promise = expectation(description: "Total pins 10")
        provider.getPins { (loadedPins, error) in
            self.pins = loadedPins
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        
        XCTAssertEqual(pins.count, 10)
        
    }
}
