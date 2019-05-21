//
//  LinkedListTest.swift
//  MAsyncLoadTests
//
//  Created by Sayooj on 20/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import XCTest
@testable import MAsyncLoad
class LinkedListTest: XCTestCase {

     let list = LinkedList<Int>()
    

   
    func testEmptyWhenCreated() {
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
        XCTAssertTrue(list.isEmpty)
    }

    
    func testAfterAppendingOnce() {
      
        list.insert(1, atIndex: 0)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.first?.value, 1)
        XCTAssertEqual(list.last?.value, 1)
    }
    
    func testAfterAppendingTwice() {
       
        list.insert(1, atIndex: 0)
        list.insert(2, atIndex: 1)
        XCTAssertEqual(list.first?.value, 1)
        XCTAssertEqual(list.last?.value, 2)
    }

    func testAfterRemovingOne() {
     
        list.insert(1, atIndex: 0)
        list.remove(atIndex: 0)
        XCTAssertNil(list.first)
    }
    
    func testAfterRemovingFromMiddle() {
        list.insert(1, atIndex: 0)
        list.insert(2, atIndex: 1)
        list.insert(3, atIndex: 2)
        
        
        list.remove(atIndex: 1)
            
        
        assert(list.first?.value == 1)
        assert(list.last?.value == 3)
    }
    
    func testAfterRemovingFromBeginning() {
        list.insert(1, atIndex: 0)
        list.insert(2, atIndex: 1)
        list.insert(3, atIndex: 2)
        
        
        list.remove(atIndex: 0)
        
        
        assert(list.first?.value == 2)
        assert(list.last?.value == 3)
    }
    
    func testAfterRemovingEnd() {
        list.insert(1, atIndex: 0)
        list.insert(2, atIndex: 1)
        list.insert(3, atIndex: 2)
        
        
        list.remove(atIndex: 2)
        
        
        assert(list.first?.value == 1)
        assert(list.last?.value == 2)
    }
    
    func testAfterRemovingAll() {
        list.insert(1, atIndex: 0)
        list.insert(2, atIndex: 1)
        list.insert(3, atIndex: 2)
        
        
        list.removeAll()
        
        
        XCTAssertNil(list.first?.value)
        XCTAssertNil(list.last?.value)
    }
}
