//
//  DriverPostsListViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 2/17/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class DriverPostsListViewController: BaseViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cnt_newRequestsAlert: NSLayoutConstraint!
    
    
    var defaultCntOfNewRequestsAlert: CGFloat = 0.0
    var deliveryRequests: [DeliveryData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var newDeliveryRequests: [DeliveryData] = [] {
        didSet {
            if self.newDeliveryRequests.count == 0 {
                cnt_newRequestsAlert.constant = 0
            } else {
                cnt_newRequestsAlert.constant = defaultCntOfNewRequestsAlert
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultCntOfNewRequestsAlert = cnt_newRequestsAlert.constant
        cnt_newRequestsAlert.constant = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    
    override func setupSocket() {
        super.setupSocket()
        let uid = SocketIOApi.shared.socket.on("bidDelivery") { (arguments, arc) in
            guard let data = arguments[0] as? [String: String] else {
                return
            }
            self.insertDeliveryIdToCell(bidId: data["bidId"]!, deliveryId: data["deliveryId"]!)
        }
        socketEventIds.append(uid)
    }
    func loadData() {
        DeliveryData.getAlldeliveryRequests { (deliveryRequests) in
            self.deliveryRequests = deliveryRequests
        }
    }
    
    func insertDeliveryIdToCell(bidId: String, deliveryId: String) {
        let index = deliveryRequests.firstIndex { (item) -> Bool in
            return item.bidId == bidId
        }
        if index != nil {
            let cell = collectionView.cellForItem(at: IndexPath(item: index!, section: 0)) as! DriverRequestCell
            cell.deliveryData?.deliverierIds.append(deliveryId)
            cell.refreshView()
            return
        }
        let deliveryData = newDeliveryRequests.first(where: { (item) -> Bool in
            return item.bidId == bidId
        })
        if deliveryData != nil {
            deliveryData?.deliverierIds.append(deliveryId)
        }
    }

    @IBAction func action_showNewRequests(_ sender: Any) {
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDeliveryRequestsDetail" {
            let deliveryData = sender as? DeliveryData
            let viewController = segue.destination as! DriverTaskDetailViewController
            viewController.deliveryData = deliveryData
        }
    }


}
extension DriverPostsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deliveryRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "driverRequestCell", for: indexPath) as! DriverRequestCell
        cell.maxWidth = collectionView.bounds.width
        cell.deliveryData = deliveryRequests[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDeliveryRequestsDetail", sender: deliveryRequests[indexPath.item])
    }
}

class DriverRequestCell: AutoHeightCollectionViewCell {
    var deliveryData: DeliveryData? {
        didSet {
            refreshView()
        }
    }
    
    func refreshView() {
        lbl_productName.text = self.deliveryData?.productName
        lbl_sellerAddress.text = self.deliveryData?.from
        lbl_buyerAddress.text = self.deliveryData?.to
        lbl_deliveryPrice.text = self.deliveryData?.deliveryPriceString
        lbl_state.isHidden = true
        if self.deliveryData?.deliverierIds.contains(User.Me.id) ?? false {
            lbl_state.text = "You bidded"
            lbl_state.isHidden = false
        }
        if let imageId = self.deliveryData?.productImageId {
            iv_product.fromImageId(imageId: imageId)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                v_background.backgroundColor = UIColor(rgb: 0xCACACA, alpha: 1)
            } else {
                v_background.backgroundColor = .white
            }
        }
    }
    
    @IBOutlet weak var iv_product: ProductThumbImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_sellerAddress: UILabel!
    @IBOutlet weak var lbl_buyerAddress: UILabel!
    @IBOutlet weak var lbl_deliveryPrice: UILabel!
    @IBOutlet weak var v_background: MyBaseView!
    @IBOutlet weak var lbl_state: UILabel!
}
