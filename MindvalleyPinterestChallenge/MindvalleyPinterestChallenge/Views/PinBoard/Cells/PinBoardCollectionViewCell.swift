//
//  PinBoardCollectionViewCell.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj Krishnan  on 17/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit
import MAsyncLoad
class PinBoardCollectionViewCell: UICollectionViewCell {
   
    
    var pin : Pin? {
        didSet{
            userInfoCardView.user = pin?.user
            categoryTagView.categories = pin?.categories
            userInfoCardView.backgroundColor = contentView.backgroundColor
            pinBoardImage.backgroundColor  = contentView.backgroundColor
            guard let pinImage = pin?.urls?.regular , let pinImageURL = URL(string: pinImage)else {
                return
            }
            pinBoardImage.loadImage(from: pinImageURL)
        }
    }
    
    let pinBoardImage : CachedImageView = {
        let imageView = CachedImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userInfoCardView : PinBordUserProfileCardView = {
        let card = PinBordUserProfileCardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    let categoryTagView : CategoryTagsView = {
       let view = CategoryTagsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerRadiusAndShadow()
    }
    
    deinit {
        print("Deinit board cell")
    }
    
    
    func configureCornerRadiusAndShadow(){
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    private func setupViews(){
        contentView.addSubview(pinBoardImage)
        contentView.addSubview(userInfoCardView)
        contentView.addSubview(categoryTagView)
        
        NSLayoutConstraint.activate([
            pinBoardImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            pinBoardImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            pinBoardImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            pinBoardImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            
            userInfoCardView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            userInfoCardView.topAnchor.constraint(equalTo: pinBoardImage.bottomAnchor),
            userInfoCardView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            userInfoCardView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.15),
            
            categoryTagView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            categoryTagView.topAnchor.constraint(equalTo: userInfoCardView.bottomAnchor),
            categoryTagView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            categoryTagView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.15),
            
            ])
    }
}
