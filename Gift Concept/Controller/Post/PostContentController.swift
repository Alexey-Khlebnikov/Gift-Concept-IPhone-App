//
//  PostContentController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/14/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class PostContentController: UIViewController {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_content: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var v_detailContainer: UIView!
    @IBOutlet weak var cnt_attachedFilesHeight: NSLayoutConstraint!
    @IBOutlet weak var clv_attachedFiles: UICollectionView!
    @IBOutlet weak var cnt_deliveryContainer: NSLayoutConstraint!
    @IBOutlet weak var lbl_deliveryMethod: UILabel!
    @IBOutlet weak var lbl_deliveryAddress: UILabel!
    @IBOutlet weak var lbl_deliveryDateAndTime: UILabel!
    @IBOutlet weak var lbl_contactPhoneNumber: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if post.deliveryMethod == 0 {
            cnt_deliveryContainer.isActive = false
            lbl_deliveryMethod.text = "By myself"
        } else {
            lbl_deliveryMethod.text = "By deliverier"
        }
        
        lbl_deliveryAddress.text = post.deliveryAddress
        lbl_deliveryDateAndTime.text = post.deliveryDateAndTime
        
        lbl_contactPhoneNumber.text = post.contactPhoneNumber

        // Do any additional setup after loading the view.
        v_detailContainer.shadow(left: 0, top: 6, feather: 20, color: .black, opacity: 0.1)
        lbl_name.text = post.name
        lbl_content.text = post.content
        lbl_price.text = post.rangePrice()
        resetCollectionViewHeight()
    }
    
    var post: Post!
    
    func resetCollectionViewHeight() {
        self.view.layoutIfNeeded()
        cnt_attachedFilesHeight.constant = clv_attachedFiles.collectionViewLayout.collectionViewContentSize.height
                
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

extension PostContentController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post.attaches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostContentAttachCell", for: indexPath) as! PostContentAttachCell
        cell.attach = post.attaches[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 113)
    }
}

class PostContentAttachCell: BaseCell {
    @IBOutlet weak var iv_productImage: URLImageView!
    @IBOutlet weak var lbl_filename: UILabel!
    @IBOutlet weak var lbl_createAt: UILabel!
    
    
    var attach: ImageInfo? {
        didSet {
            if let url = attach?.url {
                iv_productImage.fromURL(urlString: url)
            }
            lbl_filename.text =  attach?.name
            lbl_createAt.text = attach?.createdAt
        }
    }
    
    @IBAction func showAttachedImage(_ sender: Any) {
        print("showAttachedImage")
    }
}
