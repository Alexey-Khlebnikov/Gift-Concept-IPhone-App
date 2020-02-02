//
//  BellContatainerCell.swift
//  gift_app
//
//  Created by Lexy on 8/31/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

class BillContatainerCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var soldProducts: [SoldProduct]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    let cellId = "cellIds"
    
    override func setupViews() {
        super.setupViews()
        fetchSoldProducts()
        
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 15, left: 0, bottom: 50, right: 0)
        collectionView.register(SoldProductCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchSoldProducts() {
        ApiService.sharedService.fetchSoldProducts { (soldProducts: [SoldProduct]) in
            self.soldProducts = soldProducts
            self.collectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soldProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SoldProductCell
        cell.soldProduct = soldProducts?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
