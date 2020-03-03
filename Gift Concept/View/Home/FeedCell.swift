//
//  FeedCell.swift
//  gift_app
//
//  Created by Lexy on 8/30/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var categories: [Category]?
    var viewController: HomeController?
    
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
        fetchCategories()
        
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchCategories() {
        ApiService.sharedService.fetchCategories { (categries: [Category]) in
            self.categories = categries
            self.collectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.category = categories?[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
//        let launcher = ProductListLauncher()
//        launcher.showProductList()
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let newViewController = ProductListViewController(collectionViewLayout: layout)
//        newViewController.title = cell?.category?.name
//        let newViewController = ProductListController()
        viewController?.performSegue(withIdentifier: "UserProductListViewController", sender: (cell?.category?.name, cell?.category?.id))
//        viewController?.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
}
