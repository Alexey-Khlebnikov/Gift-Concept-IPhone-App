//
//  SellerCategoryViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 1/13/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class SellerCategoryViewController: BaseViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        // Do any additional setup after loading the view.
    }
    
    func fetchCategories() {
        ApiService.sharedService.fetchCategories { (categries: [Category]) in
            self.categories = categries
            self.collectionView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SellerCategoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryItemCell
        
        let tmp = flowLayout.sectionInset
        cell.maxWidth = collectionView.frame.width - tmp.left - tmp.right
        
        cell.category = self.categories[indexPath.item]
        return cell
    }
    
    
}

class CategoryItemCell: AutoHeightCollectionViewCell {
    var category: Category? {
        didSet {
            if let category = self.category {
                self.iv_category.fromURL(urlString: category.categoryURL)
                self.iv_icon.fromURL(urlString: category.categoryIconURL)
                self.lbl_name.text = category.name
            }
        }
    }
    @IBOutlet weak var iv_category: URLImageView!
    @IBOutlet weak var iv_icon: URLImageView!
    @IBOutlet weak var lbl_name: UILabel!
    
}
