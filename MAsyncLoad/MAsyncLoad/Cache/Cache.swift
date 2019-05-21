//
//  Cache.swift
//  MAsyncLoad
//
//  Created by Sayooj Krishnan  on 17/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit


/**
 This class will help to keep  only one instance of LRUCache throughout the app.
 Note :
 call configure(_ withMaxSize : Int) before calling cache property 
 
 */
public class CacheManager {
    public static let instance = CacheManager()
    
    public func configure(_ withMaxSize : Int){
        if cache == nil {
            cache = LRUCache<URL>(withMaxSize)
        }
    }
    
    /**
     Instance of LRUCache
     Make sure to call configure(_ withMaxSize : Int) to configure the cache with required  maxsize
     */
    var cache : LRUCache<URL>!

}

/**
  class handles the LRUCaching operations.
 */
public final class LRUCache<KeyType: Hashable> {

    private typealias Node =  LinkedList<KeyType>.LinkedListNode<KeyType>
    
    // Maximum size of cache
    public let maxSize: Int
    
    private var cache: [KeyType: Data] = [:]
    private var priority: LinkedList<KeyType> = LinkedList<KeyType>()
    
    //a hash table is used to store the references of each node
    private var key2node: [KeyType: Node] = [:]
    
    public init(_ maxSize: Int) {
        self.maxSize = maxSize
        NotificationCenter.default.addObserver(self, selector: #selector(removeAll), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    public func get(_ key: KeyType) -> Data? {
        guard let val = cache[key] else {
            return nil
        }
        
        remove(key)
        insert(key, val: val)
        
        return val
    }
    
    public func set(_ key: KeyType, val: Data) {
        if cache[key] != nil {
            remove(key)
        } else if priority.count >= maxSize, let keyToRemove = priority.last?.value {
            remove(keyToRemove)
        }
        
        insert(key, val: val)
    }
    
    private func remove(_ key: KeyType) {
        cache.removeValue(forKey: key)
        guard let node = key2node[key] else {
            return
        }
        priority.remove(node: node)
        key2node.removeValue(forKey: key)
    }
    
    private func insert(_ key: KeyType, val: Data) {
        cache[key] = val
        priority.insert(key, atIndex: 0)
        guard let first = priority.first else {
            return
        }
        key2node[key] = first
    }
    
    
   @objc private func removeAll(){
        cache.removeAll()
        priority.removeAll()
        key2node.removeAll()
   }
}
