//
//  File.swift
//  MAsyncLoad
//
//  Created by Sayooj on 20/05/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import Foundation
public class ImageLoadOperation : AsyncOperation  {
    
    public var image : UIImage?
    public var url : URL
    public init(url :URL) {
        self.url = url
    }
    
    override public func main() {
        NetworkClient.shared.fetch(url: url) { (resultRes) in
            guard self.isCancelled == false else {
                self.image = nil
                self.state = .finished
                return
            }
            switch resultRes {
            case .Success(let data):
                if let imageData = data,let i = UIImage(data: imageData){
                    self.image = i
                }
            case .Error(_) :
                self.image = nil
            }
            self.state = .finished
        }
    }
    
}
