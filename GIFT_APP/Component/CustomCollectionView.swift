//
//  CustomCollectionView.swift
//  gift_app
//
//  Created by Lexy on 10/1/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

class CustomCollectionView: MyBaseView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var delegate: CustomCollectionViewDelegate?
    var cellSpacing: CGFloat = 8 {
        didSet {
            refresh()
        }
    }
    var cellSize: ((Int) -> (groupCount: Int, itemSize: CGFloat)) = {
        func defaultCellSize(index: Int) -> (groupCount: Int, itemSize: CGFloat) {
            fatalError("cellSize: ((Int) -> (groupCount: Int, itemSize: CGFloat)) has not been implemented")
        }
        return defaultCellSize
    }()
    
    var cellForItemAt: ((UICollectionView, IndexPath) -> UICollectionViewCell) = {
        func defaultCellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            fatalError("cellForItemAt: ((UICollectionView, IndexPath) -> UICollectionViewCell) has not been implemented")
        }
        return defaultCellForItemAt
    }()
    
    var numberOfItemsInSection: ((UICollectionView, Int) -> Int) = {
        func defaultNumberOfItemsInSection(collectionView: UICollectionView, section: Int) -> Int {
            fatalError("numberOfItemsInSection: ((UICollectionView, Int) -> Int) has not been implemented")
        }
        return defaultNumberOfItemsInSection(collectionView:section:)
    }()
    
    var didSelectItemAt: ((UICollectionView, IndexPath) -> ()) = {
        func defaultDidSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            fatalError("ndidSelectItemAt: ((UICollectionView, IndexPath) -> ()) has not been implemented")
        }
        return defaultDidSelectItemAt
    }()
    
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            refresh()
        }
    }
    
    var direction: UICollectionView.ScrollDirection! {
        didSet {
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = direction
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        direction = .horizontal
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(collectionView, didSelectItemAt: indexPath) ?? didSelectItemAt(collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItemsInSection(collectionView, numberOfItemsInSection: section) ?? numberOfItemsInSection(collectionView, section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell_size = delegate?.cellSize(index: indexPath.item) ?? cellSize(indexPath.item)
        
        var width = cell_size.itemSize, height = cell_size.itemSize
        
        if(direction == .vertical) {
            width = (collectionView.frame.width + cellSpacing - padding.left - padding.right) / CGFloat(cell_size.groupCount) - cellSpacing
        } else {
            height = (collectionView.frame.height + cellSpacing - padding.top - padding.bottom) / CGFloat(cell_size.groupCount) - cellSpacing
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate?.cellForItemAt(collectionView, cellForItemAt: indexPath) ?? cellForItemAt(collectionView, indexPath)
    }
    
}

protocol CustomCollectionViewDelegate {
    func numberOfItemsInSection(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func cellSize(index: Int) -> (groupCount: Int, itemSize: CGFloat)
    func didSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
