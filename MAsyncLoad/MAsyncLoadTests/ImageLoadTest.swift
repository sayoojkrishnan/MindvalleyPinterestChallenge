//
//  CachedImageViewTest.swift
//  MAsyncLoadTests
//
//  Created by Sayooj on 21/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import XCTest
@testable import MAsyncLoad
class ImageLoadTest : XCTestCase {
    
    var image : UIImage!
    
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "image", ofType: "jpg")
        self.image = UIImage(contentsOfFile: path!)
    }
    override func tearDown() {
        self.image = nil
    }
    
    func testImageLoaderSuccess(){
        let promise = expectation(description: "Image data ")
        let url = URL(string: "https://images.unsplash.com/photo-1464547323744-4edd0cd0c746?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=04ae475c7890dc860eb7a24b590e008b")!
        let operation = ImageLoadOperation(url: url)
        
        ImageLoader.instance.start(operation: operation)
        
        operation.completionBlock = {
            if operation.image != nil {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 10)
        XCTAssertEqual(operation.image!.pngData(), image.pngData())
    }
    
}
