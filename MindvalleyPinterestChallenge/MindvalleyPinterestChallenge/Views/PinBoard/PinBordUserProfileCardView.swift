//
//  PinBordUserProfileCardView.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj Krishnan  on 18/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit
import MAsyncLoad
class PinBordUserProfileCardView : UIView {
    
    var user : User? {
        didSet {
            userNameLabel.text = user?.name
            guard let profileImage = user?.profileImage?.small , let profileImageURL = URL(string: profileImage)  else{
                return
            }
            userImageView.loadImage(from: profileImageURL)
        }
    }
    
    let userImageView : CachedImageView = {
        let imageView = CachedImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.darkGray
        return imageView
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.textColor = .gray
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTrait = previousTraitCollection ,
            traitCollection.verticalSizeClass != previousTrait.verticalSizeClass  else {
            return
        }
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            userNameLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
        }
        else {
            userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        handleUserNameLabelColor()
    }
    
    private func handleUserNameLabelColor (){
        if let isDarkBackgroundColor =  backgroundColor?.isDarkColor , isDarkBackgroundColor {
            userNameLabel.textColor = .white
        }else {
            userNameLabel.textColor = .gray
        }
    }
    
    
    private func setupViews(){
        addSubview(userImageView)
        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            
            userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            userNameLabel.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }
}

