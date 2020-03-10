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
                self.collectionView.reloadData()
            }
        }
    }
    var deliveryData: DeliveryData? {
        didSet {
            renderData()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var deliveriers: [(deliverier: User, state: DeliveryState)] = []
    
    func renderData() {
        deliveriers = []
        if let deliveryData = self.deliveryData {
            var dic: [String: User] = [:]
            for deliverier in deliveryData.deliveriers {
                dic[deliverier.id] = deliverier
            }
            if deliveryData.deliveryId != nil {
                self.deliveriers.append((dic[deliveryData.deliveryId]!, .accepted))
                dic.removeValue(forKey: deliveryData.deliveryId)
            }
            for deliverierId in deliveryData.awardedDeliverierIds {
                self.deliveriers.append((dic[deliverierId]!, .awarded))
                dic.removeValue(forKey: deliverierId)
            }
            for (_, deliverier) in dic {
                self.deliveriers.append((deliverier, .bidded))
            }
        }
    }
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadData()
    }
    
    private func loadData() {
        if let bidId = sender as? String {
            DeliveryData.getDeliveryDataForSeller(bidId: bidId) { (deliveryData) in
                self.deliveryData = deliveryData
            }
        }
    }
    
    override func setupSocket() {
        socketEventIds.append(SocketIOApi.shared.socket.on("", callback: { (arguments, arc) in
            guard let data = arguments[0] as? [String: String] else {
                return
            }
//            DeliveryData.getData(bidId: data["bidId"]!) { (deliveryData) in
//                self.deliveryDataList.append(deliveryData)
//            }
        }))
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
        return deliveriers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let temp = flowLayout.sectionInset
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerDeliveryRequestViewCell", for: indexPath) as! SellerDeliveryRequestViewCell
        cell.maxWidth = collectionView.frame.width - temp.left - temp.right
        cell.viewController = self
        cell.deliveryData = deliveryData
        cell.data = deliveriers[indexPath.item]
        
        return cell
    }
    
}

class SellerDeliveryRequestViewCell: AutoHeightCollectionViewCell {
    
    
    var deliveryData: DeliveryData!
    var data: (deliverier: User, state: DeliveryState)! {
        didSet {
            deliverier = self.data.deliverier
            refreshView()
        }
    }
    
    private var deliverier: User!
    
    private var stateData: [DeliveryState: String] = [
        DeliveryState.accepted: "Accepted",
        DeliveryState.awarded: "Waiting Acception",
        DeliveryState.bidded: ""
    ]
    
    func refreshView() {
        lbl_deliverierName.text = deliverier.username
        ratingView.value = CGFloat(4.2)
        aiv_avatar.fromURL(urlString: deliverier.avatar)
        
        btn_award.isHidden = data.state != .bidded
        lbl_state.isHidden = data.state == .bidded
        lbl_state.text = stateData[data.state]
    }
    
    
    @IBOutlet weak var aiv_avatar: AvatarImageView!
    @IBOutlet weak var lbl_deliverierName: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var btn_award: BaseButton!
    @IBOutlet weak var lbl_state: UILabel!
    
    @IBAction func action_award(_ sender: Any) {
        deliveryData.award(deliverierId: deliverier.id) { (response) in
            if response.error != nil {
                
            }
        }
    }
    
}

