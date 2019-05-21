//
//  AsyncOperation.swift
//  MAsyncLoad
//
//  Created by Sayooj on 20/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import Foundation
public class AsyncOperation : Operation {
    public enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
}
extension AsyncOperation {
    
    override public var isAsynchronous: Bool {
        return true
    }
    
    override public var isExecuting: Bool {
        return state == .executing
    }
    
    override public var isFinished: Bool {
        return state == .finished
    }
    
    
    
    override public func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
}
