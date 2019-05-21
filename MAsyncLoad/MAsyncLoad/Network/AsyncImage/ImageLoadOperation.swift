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
        NetworkClient.shared.fetch(url: url) {[weak self] (resultRes) in
            guard let this = self else {return}
            guard this.isCancelled == false else {
                this.image = nil
                this.state = .finished
                return
            }
            switch resultRes {
            case .Success(let data):
                if let imageData = data,let i = UIImage(data: imageData){
                    this.image = i
                }
            case .Error(_) :
                this.image = nil
            }
            this.state = .finished
        }
    }
    
}
