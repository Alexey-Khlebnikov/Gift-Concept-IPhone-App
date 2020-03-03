//
//  SellerBuyOrderDetailViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/12/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class SellerBuyOrderDetailViewController: BaseViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cnt_collectionView: NSLayoutConstraint!
    @IBOutlet weak var lbl_postName: UILabel!
    @IBOutlet weak var lbl_postDetail: UILabel!
    @IBOutlet weak var lbl_postPrice: UILabel!
    @IBOutlet weak var lbl_deliveryAddress: UILabel!
    @IBOutlet weak var lbl_deliverySchedule: UILabel!
    @IBOutlet weak var lbl_deliveryPrice: UILabel!
    
    var post: Post? {
        didSet {
            collectionView.reloadData()
            if let post = post {
                lbl_postName.text = post.name
                lbl_postDetail.text = post.content
                lbl_postPrice.text = post.rangePrice()
                lbl_deliveryAddress.text = post.deliveryAddress
                lbl_deliverySchedule.text = post.deliveryDateAndTime
                lbl_deliveryPrice.text = post.getFullPrice(price: post.deliveryPrice)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        loadData()
    }
    
    func loadData() {
        Post.get(postId: sender as? String) { (post) in
            self.post = post
        }
    }
    
    
    func setHeightToCollectionView() {
        cnt_collectionView.constant = flowLayout.collectionViewContentSize.height
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == self.collectionView {
            setHeightToCollectionView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collectionView?.removeObserver(self, forKeyPath: "contentSize")
    }

}

extension SellerBuyOrderDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post?.attaches.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tmp = flowLayout.sectionInset
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachImageCell", for: indexPath) as! AttachImageCell
        
        cell.maxWidth = collectionView.frame.width - tmp.left - tmp.right
        let attach = post!.attaches[indexPath.item]
        cell.attachImage.fromURL(urlString: attach.url)
        return cell
    }
}


class AttachImageCell: AutoHeightCollectionViewCell {
    var imageInfo: ImageInfo? {
        didSet {
            if let url = self.imageInfo?.url {
                attachImage.fromURL(urlString: url)
            }
            attachName.text = self.imageInfo?.name
            attachTimeAgo.text = Date().elapsedTime
        }
    }

    @IBOutlet weak var attachImage: ProductThumbImageView!
    @IBOutlet weak var attachName: UILabel!
    @IBOutlet weak var attachTimeAgo: UILabel!
    
}

