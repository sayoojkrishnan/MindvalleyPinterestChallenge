//
//  UICollectionView+Extesions.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj on 19/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit
extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 16)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restoreBackgroundView() {
        self.backgroundView = nil
    }
}
