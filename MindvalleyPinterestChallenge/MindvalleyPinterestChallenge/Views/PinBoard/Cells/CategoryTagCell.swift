//
//  CategoryTagCell.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj on 18/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit
class CategoryTagCell: UICollectionViewCell {
    
    var category :  Pin.Category? {
        didSet{
            titleLabel.text = category?.title
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        contentView.backgroundColor = UIColor.lightGray
        contentView.clipsToBounds = true
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTrait = previousTraitCollection ,
            traitCollection.verticalSizeClass != previousTrait.verticalSizeClass  else {
                return
        }
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            titleLabel.font = UIFont.systemFont(ofSize: 18)
        }
        else {
            titleLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }
}
