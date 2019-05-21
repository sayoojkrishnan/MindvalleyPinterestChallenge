//
//  BoardCollectionViewController.swift
//  MindvalleyPinterestChallenge
//
//  Created by Sayooj Krishnan  on 17/05/19.
//  Copyright © 2019 Sayooj Krishnan . All rights reserved.
//

import UIKit
 


class PinBoardCollectionViewController: UIViewController {
    
    private enum PinRequestType {
        case load
        case reload
        case paginate
    }
    
    private enum State {
        case loading
        case ready
        case paginating
        case reloading
    }
    
    private struct CellSize {
        static let interItemSpacing : CGFloat = 5
        static let lineSpacing : CGFloat = 10
        static let sectionInsetLeft : CGFloat = 10
        static let sectionInsetTop : CGFloat = 10
        static let sectionInsetBottom : CGFloat = 10
        static let sectionInsetRight : CGFloat = 10
    }
    private struct CellCount  {
        static let landscapeXAxis : CGFloat   = 3
        static let landscapeYAxis : CGFloat  = 1.5
        static let portraitXAxis : CGFloat  = 2
        static let portraitYAxis : CGFloat  = 2.5
    }
    
    
    private let loadingSpinner : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private struct CellIndetifiers {
        static  let reuseIdentifier = "pinCell"
        static let paginationFooterId = "paginationFooter"
    }
    
    
    private var state : State = State.loading
    
    private let pinsProvider = PinBoardDataProvider()
    private var pins : [Pin] = [Pin]()
    
    // Pagination
    private let totalDataAvilable = 100
    private var currentPage = 1
    private let refreshControl = UIRefreshControl()
    
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CellSize.lineSpacing
        layout.minimumInteritemSpacing = CellSize.interItemSpacing
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: CellSize.sectionInsetTop, left: CellSize.sectionInsetLeft, bottom: CellSize.sectionInsetBottom, right: CellSize.sectionInsetRight )
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.alwaysBounceVertical = true
        cv.register(PinBoardCollectionViewCell.self, forCellWithReuseIdentifier: CellIndetifiers.reuseIdentifier)
        cv.register(PinBoardPaginationIndicatorFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CellIndetifiers.paginationFooterId)
        return cv
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        loadPins(type: .load)
        
    }
    
    
    private func setupSubViews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        configurePullToRefresh()
    }
    
    
    private func loadPins(type : PinRequestType){
      
        if type == .load {
            showLoadingSpinner()
        }
        pinsProvider.getPins { (loadedPins, error) in
            guard error == nil else{
                DispatchQueue.main.async {
                    self.hideLoadingSpinner()
                    self.showErrorAlert()
                }
                return
            }
            switch type {
            case .load , .reload :
                self.pins = loadedPins
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.endRefreshing()
                }
            case .paginate :
                let indexPaths = Array(self.pins.count...(self.pins.count-1+loadedPins.count)).map({IndexPath(item: $0, section: 0)})
                let _ =  loadedPins.map({self.pins.append($0)})
                DispatchQueue.main.async {
                    self.collectionView.insertItems(at: indexPaths)
                }
            }
            self.state = .ready
            DispatchQueue.main.async {
                 self.hideLoadingSpinner()
            }
        }
    }
    
    private func paginate(){
        if pins.count <= totalDataAvilable && (state == .ready) {
            self.state = .paginating
            self.currentPage += 1
            
            // To fake a delay in pagination
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadPins(type: .paginate)
            }
        }
    }
    
    
    private func showErrorAlert(){
        let alert = UIAlertController(title: "Warning", message: "Failed to load pins from server", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {[unowned self] (didTapOk) in
            self.state = .ready
            self.collectionView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension PinBoardCollectionViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pins.count == 0 && state == .ready{
            collectionView.setEmptyMessage("No new pins lately")
        }else {
            collectionView.restoreBackgroundView()
        }
        return pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndetifiers.reuseIdentifier, for: indexPath) as! PinBoardCollectionViewCell
        if let hex = pins[indexPath.row].color  {
            cell.contentView.backgroundColor = UIColor(hexFromString: hex)
        }
        cell.pin = pins[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            let verticalSpaceToOmit =  CellSize.sectionInsetTop + CellSize.sectionInsetBottom  + (CellCount.landscapeYAxis * CellSize.lineSpacing)
            let horizontalSpaceToOmit =  CellSize.sectionInsetTop + CellSize.sectionInsetBottom  + (CellCount.landscapeXAxis * CellSize.lineSpacing)
            
            let height = (collectionView.frame.height - verticalSpaceToOmit) / CellCount.landscapeYAxis 
            let width = (collectionView.frame.width - horizontalSpaceToOmit) / CellCount.landscapeXAxis
            return CGSize(width: width, height: height)
        }
        let verticalSpaceToOmit =  CellSize.sectionInsetLeft + CellSize.sectionInsetRight  + (CellCount.portraitYAxis * CellSize.interItemSpacing)
        
        let horizontalSpaceToOmit =  CellSize.sectionInsetLeft + CellSize.sectionInsetRight  + (CellCount.portraitXAxis * CellSize.interItemSpacing)
        let height = (collectionView.frame.height - verticalSpaceToOmit) / CellCount.portraitYAxis
        let width = (collectionView.frame.width - horizontalSpaceToOmit) / CellCount.portraitXAxis
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == pins.count - 1 {
            paginate()
        }
        doSpringAnimation(onCell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let  reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellIndetifiers.paginationFooterId, for: indexPath) as! PinBoardPaginationIndicatorFooter
        if self.pins.count > 0 && self.pins.count < totalDataAvilable{
            reusableView.startSpinning()
        }else {
            reusableView.stopSpinning()
        }
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}

// Loading Spinner
extension PinBoardCollectionViewController {
    private func showLoadingSpinner(){
        self.view.addSubview(loadingSpinner)
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        loadingSpinner.startAnimating()
    }
    
    private func hideLoadingSpinner() {
        if loadingSpinner.superview != nil {
            loadingSpinner.stopAnimating()
            loadingSpinner.removeFromSuperview()
        }
    }
}


// Pull to refresh controls
extension PinBoardCollectionViewController {
    private func configurePullToRefresh(){
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }
    @objc private func didPullToRefresh(_ sender: Any) {
        state = .reloading
        refreshControl.beginRefreshing()
        loadPins(type: .reload)
    }

    private func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

// Cell animation
extension PinBoardCollectionViewController {
    
    private func doSpringAnimation(onCell cell: UICollectionViewCell ){
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
}
