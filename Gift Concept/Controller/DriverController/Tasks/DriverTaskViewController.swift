//
//  DriverTaskViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 2/17/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class DriverTaskViewController: BaseViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    @IBOutlet weak var collectoinView: UICollectionView!
    
    var tasks: [DeliveryData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectoinView.reloadData()
            }
        }
    }
    
    override func setupSocket() {
        socketEventIds.append(SocketIOApi.shared.socket.on("awardDelivery", callback: { (arguments, arc) in
            
            guard let data = arguments[0] as? [String: String] else {
                return
            }
            let bidId = data["bidId"]!
            let deliverierId = data["deliverierId"]!
            if deliverierId == User.Me.id {
                DeliveryData.getDeliveryDataForSeller(bidId: bidId) { (deliveryData) in
                    self.tasks.append(deliveryData)
                    DispatchQueue.main.async {
                        self.collectoinView.reloadData()
                    }
                }
            }
        }))
        socketEventIds.append(SocketIOApi.shared.socket.on("acceptDelivery") { (arguments, arc) in
            guard let data = arguments[0] as? [String: String] else {
                return
            }
            let bidId = data["bidId"]!
            let deliveryId = data["deliveryId"]!
            var i = 0
            var deliveryData: DeliveryData?
            for task in self.tasks {
                if task.bidId == bidId {
                    deliveryData = task
                    break
                }
                i = i + 1
            }
            if deliveryData != nil {
                let cell = self.collectoinView.cellForItem(at: IndexPath(item: i, section: 0)) as! DriverTaskCell
                deliveryData?.deliveryId = deliveryId
                cell.deliveryData = deliveryData
                cell.refreshCell()
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        DeliveryData.getMyDeliveryTasks { (list) in
            self.tasks = list
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDeliveryRequestsDetailFromTask" {
            let deliveryData = sender as? DeliveryData
            let viewController = segue.destination as! DriverTaskDetailViewController
            viewController.deliveryData = deliveryData
        }
    }

}

extension DriverTaskViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DriverTaskCell", for: indexPath) as! DriverTaskCell
        cell.maxWidth = collectionView.frame.width
        cell.deliveryData = tasks[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDeliveryRequestsDetailFromTask", sender: self.tasks[indexPath.item])
    }
}

class DriverTaskCell: AutoHeightCollectionViewCell {
    var deliveryData: DeliveryData? {
        didSet {
            refreshCell()
        }
    }
    func refreshCell() {
        if let imageId = self.deliveryData?.productImageId {
            iv_productImage.fromImageId(imageId: imageId)
        }
        lbl_productName.text = self.deliveryData?.productName
        lbl_sellerPosition.text = self.deliveryData?.from
        lbl_buyerPosition.text = self.deliveryData?.to
        lbl_deliveryPrice.text = self.deliveryData?.deliveryPriceString
        if deliveryData?.deliveryId == User.Me.id {
            lbl_status.isHidden = false
            lbl_status.text = "Accepted"
            btn_accept.isHidden = true
            btn_revoke.isHidden = true
        } else {
            lbl_status.isHidden = true
            btn_accept.isHidden = false
            btn_revoke.isHidden = false
        }
    }
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                backgroundColor = UIColor(rgb: 0xCACACA, alpha: 1)
            } else {
                backgroundColor = .white
            }
        }
    }
    
    
    @IBOutlet weak var iv_productImage: ProductThumbImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_sellerPosition: UILabel!
    @IBOutlet weak var lbl_buyerPosition: UILabel!
    @IBOutlet weak var lbl_deliveryPrice: UILabel!
    @IBOutlet weak var btn_accept: UIButton!
    @IBOutlet weak var btn_revoke: BaseButton!
    @IBOutlet weak var lbl_status: UILabel!
    
    @IBAction func action_revoke(_ sender: Any) {
    }
    @IBAction func action_accept(_ sender: Any) {
        deliveryData?.accept { (response) in
            
        }
    }
}
