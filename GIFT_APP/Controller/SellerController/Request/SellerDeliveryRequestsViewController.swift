//
//  SellerDeliveryRequestsViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/9/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class SellerDeliveryRequestsViewController: BaseViewController {
    var deliveryDataList: [DeliveryData] = [] {
        didSet {
            DispatchQueue.main.async {
            }
        }
    }
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    private func loadData() {
        DeliveryData.getList { (list) in
            self.deliveryDataList = list
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

extension SellerDeliveryRequestsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deliveryDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let temp = flowLayout.sectionInset
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerDeliveryRequestViewCell", for: indexPath) as! SellerDeliveryRequestViewCell
        cell.maxWidth = collectionView.frame.width - temp.left - temp.right
        cell.viewController = self
        cell.deliveryData = deliveryDataList[indexPath.item]
        
        return cell
    }
    
}

class SellerDeliveryRequestViewCell: AutoHeightCollectionViewCell {
    var deliveryData: DeliveryData? {
        didSet {
            aiv_avatar.fromURL(urlString: "girl.png")
        }
    }
    @IBOutlet weak var aiv_avatar: AvatarImageView!
    
}
