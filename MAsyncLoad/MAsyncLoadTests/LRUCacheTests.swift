//
//  LRUCacheTests.swift
//  MAsyncLoadTests
//
//  Created by Sayooj on 20/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import XCTest
@testable import MAsyncLoad

class LRUCacheTests: XCTestCase {
    
    let lru = LRUCache<String>(2)
    func testLRUCache(){
        
        lru.set("key1", val: Data(count: 1))
        lru.set("key2", val: Data(count: 2))
        
        XCTAssertEqual(lru.get("key1"), Data(count: 1))
        XCTAssertEqual(lru.get("key2"), Data(count: 2))
    }
    
    func testLRUCacheEviction(){
        
        lru.set("key1", val: Data(count: 1))
        lru.set("key2", val: Data(count: 2))
        lru.set("key3", val: Data(count: 2))
        
        XCTAssertNil(lru.get("key1"))
    }
    
    func testLRUCacheInvalidKey(){
        lru.set("key1", val: Data(count: 1))
        lru.set("key2", val: Data(count: 2))
        
        
        XCTAssertNil(lru.get("key3"))
        
    }
    
}
