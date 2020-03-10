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
        super.setupSocket()
        SocketIOApi.shared.socket.on("bidDelivery") { (arguments, arc) in
            guard let data = arguments[0] as? [String: String] else {
                return
            }
//            self.deliveryData.deliverierIds.append(data["deliveryId"]!)
//            self.setupControlBtns()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print("DriverTaskViewController viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        DeliveryData.getAlldeliveryRequests { (list) in
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
            if let imageId = self.deliveryData?.productImageId {
                iv_productImage.fromImageId(imageId: imageId)
            }
            lbl_productName.text = self.deliveryData?.productName
            lbl_sellerPosition.text = self.deliveryData?.from
            lbl_buyerPosition.text = self.deliveryData?.to
            lbl_deliveryPrice.text = self.deliveryData?.deliveryPriceString
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
    
    @IBAction func action_revoke(_ sender: Any) {
    }
    @IBAction func action_accept(_ sender: Any) {
    }
}
