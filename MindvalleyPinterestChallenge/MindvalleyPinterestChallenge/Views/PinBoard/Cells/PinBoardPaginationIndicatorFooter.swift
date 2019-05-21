//
//  PinBoardPaginationIndicatorFooter.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj on 19/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit
class PinBoardPaginationIndicatorFooter : UICollectionReusableView {
    
    
    private let loadingSpinner : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingSpinner)
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    func startSpinning() {
        loadingSpinner.startAnimating()
    }
    func stopSpinning(){
        loadingSpinner.stopAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}


