//
//  ImageLoader.swift
//  MAsyncLoad
//
//  Created by Sayooj on 20/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit



class ImageLoader {
    private let operationQueue: OperationQueue = OperationQueue()
    public static let instance = ImageLoader()
    
    func start(operation : ImageLoadOperation){
        operationQueue.addOperation {
            operation.start()
        }
    }
}
