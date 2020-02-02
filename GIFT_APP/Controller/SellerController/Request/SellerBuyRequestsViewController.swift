//
//  SellerBuyRequestsViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/9/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class SellerBuyRequestsViewController: BaseViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StoreSellerPost.buyRequestsViewController = self
        loadData()
    }
    
    override func setupSocket() {
        super.setupSocket()
        
        SocketIOApi.shared.socket.on("awardProposal") { (arguments, arc) in
            let bidId = arguments[0] as! String
            BidData.get(id: bidId) { (bidData) in
                self.awardedBidList.insert(bidData, at: 0)
                self.collectionView.reloadData()
            }
        }
        SocketIOApi.shared.socket.on("acceptAward") { (arguments, arc) in
            let bidId = arguments[0] as! String
            let index = self.awardedBidList.firstIndex { (bidData) -> Bool in
                return bidData.id == bidId
            }
            if index == nil {
                return
            }
            
            let bidData = self.awardedBidList[index!]
            bidData.state = PostState.acceptted
            self.collectionView.reloadItems(at: [IndexPath(item: index!, section: 0)])
        }
        SocketIOApi.shared.socket.on("revokeProposal") { (arguments, arc) in
            let bidId = arguments[0] as! String
//            let bidState = arguments[1] as! String
//            if let bidData = self.bidData {
//                if bidData.id == bidId {
//                    bidData.state = bidState
//                    self.refreshState()
//                }
//            }
        }
    }
    
    var awardedBidList: [BidData] = []
    
    func loadData() {
        BidData.getAwardedProposalsOfSeller { (bidList) in
            self.awardedBidList = bidList
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SellerOrdersContainerViewController" {
            let vc = segue.destination as! SellerOrdersContainerViewController
            vc.postId = sender as? String
        }
    }

}

extension SellerBuyRequestsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awardedBidList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let temp = flowLayout.sectionInset
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerBuyRequestsViewCell", for: indexPath) as! SellerBuyRequestsViewCell
        cell.maxWidth = collectionView.frame.width - temp.left - temp.right
        cell.viewController = self
        cell.bidData = awardedBidList[indexPath.item]
        return cell
    }
    
    
}


class SellerBuyRequestsViewCell: AutoHeightCollectionViewCell {
    @IBOutlet weak var lbl_postName: UILabel!
    @IBOutlet weak var lbl_postDetail: UILabel!
    @IBOutlet weak var lbl_buyerName: UILabel!
    @IBOutlet weak var lbl_bidPrice: UILabel!
    @IBOutlet weak var lbl_stateTime: UILabel!
    @IBOutlet weak var btn_accept: BaseButton!
    @IBOutlet weak var lbl_state: UILabel!
    
    var bidData: BidData? {
        didSet {
            if let bidData = self.bidData {
                lbl_postName.text = bidData.post?.name
                lbl_postDetail.text = bidData.post?.content
                if let buyer = bidData.post?.buyer {
                    lbl_buyerName.text = buyer.username
                } else {
                    lbl_buyerName.text = "Guest"
                }
                lbl_bidPrice.text = bidData.post?.getFullPrice(price: bidData.bidPrice)
            }
            refreshState()
        }
    }
    
    @IBAction func goToViewDetail(_ sender: Any) {
        self.viewController?.performSegue(withIdentifier: "SellerOrdersContainerViewController", sender: bidData?.postId)
    }
    
    
    func refreshState() {
        if let bidData = self.bidData {
            btn_accept.isHidden = bidData.state != PostState.awaiting
            lbl_state.text = bidData.state
            lbl_state.isHidden = !btn_accept.isHidden
        }
    }
}
