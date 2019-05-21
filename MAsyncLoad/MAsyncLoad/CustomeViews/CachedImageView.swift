//
//  CachedImageView.swift
//  MAsyncLoad
//
//  Created by Sayooj on 17/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit
// CachedImageView
open class CachedImageView : UIImageView {
    
    var imageURL : URL?
    
    public var progressBarColor : UIColor? {
        didSet{
            progressIndicator.color = progressBarColor
        }
    }
    public var errorMessage : String? {
        didSet{
            infoTitle.text = errorMessage
        }
    }
   public var errorMessageColor : UIColor? {
        didSet{
            infoTitle.textColor = errorMessageColor
        }
    }
    
   public var placeHolderImage : UIImage?
    
   public var failurePlaceholder : UIImage?
    
    
    public var fetchOperation : ImageLoadOperation?
    
    private lazy var progressIndicator : UIActivityIndicatorView = {
        let pi = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        pi.hidesWhenStopped =  true
        pi.color = self.backgroundColor?.isDarkColor ?? false ? .white : .gray
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    
    
    private let infoTitle : UILabel = {
        let label = UILabel()
        label.text = "Failed to load.\nTap to retry"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    public enum Option  {
        case withPlaceholderImage
        case withActivityIndicator
    }
    
    public var utilityOptions : [Option] = [Option]()
    
    let im = ImageLoader.instance
    
    open override var image: UIImage? {
        didSet {
            self.progressIndicator.stopAnimating()
            self.progressIndicator.removeFromSuperview()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureTapGesture()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Loads remote image from url
     - parameter : from url : URL path of image
     - parameter : withOption
     Default to [.withActivityIndicator]
     1-  if .withPlaceholderImage is given then a placeholder will be shown while loading or failure
     Make sure to set  placeHolderImage : UIImage? , failurePlaceholder : UIImage? property with according UIImages
     
     2- For .withActivityIndicator and activityIndicator will be displayed while loading ,in case of an error a UIlabel with default text Failed to load.\nTap to retry.  will be displayed. The text and color can be updated by setting errorMessage and errorMessageColor respctively
     3.Use
     
     */
    public func loadImage(from url : URL , withOptions options :[Option] = [.withActivityIndicator] ) {
        self.imageURL = url
        self.utilityOptions = options
        self.fetchOperation = ImageLoadOperation(url: url)
        self.image = nil
        self.hideError()
        if options.contains(.withPlaceholderImage) {
            self.image = placeHolderImage
        }else{
            setupAndStartActivityIndicator()
        }
        im.start(operation: fetchOperation!)
        fetchOperation?.completionBlock =  {
            if url == self.imageURL {
                if self.fetchOperation?.image != nil {
                    DispatchQueue.main.async {
                        UIView.transition(with: self,
                                          duration:0.5,
                                          options: .transitionCrossDissolve,
                                          animations: { self.image = self.fetchOperation?.image },
                                          completion: nil)
                    }
                }else {
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        if options.contains(.withActivityIndicator){
                            self.showError()
                        }else{
                            self.image = self.failurePlaceholder
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    private func configureTapGesture(){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.retry(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc open func retry(sender : UIButton){
        if let url = self.imageURL ,let operation =  self.fetchOperation,
            operation.isFinished && operation.image == nil  {
            loadImage(from: url,withOptions: utilityOptions)
        }
    }
    
    private func setupAndStartActivityIndicator() {
        addSubview(progressIndicator)
        progressIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.progressIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        self.progressIndicator.stopAnimating()
        self.progressIndicator.removeFromSuperview()
    }
    
    
    private func showError() {
        self.addSubview(self.infoTitle)
        self.infoTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.infoTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    private func hideError(){
        if infoTitle.superview != nil {
            infoTitle.removeFromSuperview()
        }
    }
    
}

