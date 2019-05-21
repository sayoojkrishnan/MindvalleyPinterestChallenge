//
//  UIColorExtesionsTest.swift
//  MindvalleyPinterestChallengeTests
//
//  Created by Sayooj on 21/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import XCTest
@testable import MindvalleyPinterestChallenge
class UIColorExtesionsTest: XCTestCase {

    
    
    func testIsDarkColor(){
        
        XCTAssertEqual(UIColor.black.isDarkColor,true)
        XCTAssertEqual(UIColor.blue.isDarkColor,true)
        XCTAssertEqual(UIColor.red.isDarkColor,true)
        XCTAssertEqual(UIColor.white.isDarkColor,false)
        XCTAssertEqual(UIColor.blue.isDarkColor,true)
        XCTAssertEqual(UIColor.green.isDarkColor,false)
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
