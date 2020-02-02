//
//  PostProposalsController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/16/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import HCSStarRatingView

class PostProposalsController: UIViewController {

    @IBOutlet weak var clv_awardedSellers: UICollectionView!
    @IBOutlet weak var clv_otherProposals: UICollectionView!
    
    @IBOutlet weak var cnt_awardHeight: NSLayoutConstraint!
    @IBOutlet weak var cnt_proposalHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_viewMore: BaseButton!
    @IBOutlet weak var cnt_viewMore: NSLayoutConstraint!
    
    var socketEventIds: [UUID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cnt_viewMore.constant = 0
        setupSockets()
    }
    
    func setupSockets() {
        let uuid = SocketIOApi.shared.socket.on("newProposal") { (arguments, ack) in
            let bidData = BidData(arguments[0] as! [String: AnyObject])
            self.newProposals.append(bidData)
        }
        SocketIOApi.shared.socket.on("acceptAward") { (arguments, ack) in
            let bidId = arguments[0] as! String
            let index = self.awardProposals.firstIndex { (bidData) -> Bool in
                return bidData.id == bidId
            }
            if index != nil {
                self.awardProposals[index!].state = PostState.acceptted
                DispatchQueue.main.async {
                    self.clv_awardedSellers.reloadItems(at: [IndexPath(item: index!, section: 0)])
                }
            }
        }
        SocketIOApi.shared.socket.on("awardProposal") { (arguments, ack) in
            let bidId = arguments[0] as! String
            var index = self.totalProposals.firstIndex { (bidData) -> Bool in
                return bidData.id == bidId
            }
            if index != nil {
                self.totalProposals[index!].state = PostState.awaiting
                self.changedTotalProposals()
            } else {
                index = self.newProposals.firstIndex { (bidData) -> Bool in
                    return bidData.id == bidId
                }
                if index != nil {
                    self.newProposals[index!].state = PostState.awaiting
                }
            }
        }
        socketEventIds.append(uuid)
    }
    
    var newProposals: [BidData] = [] {
        didSet {
            if self.newProposals.count > 0 {
                btn_viewMore.setTitle("Click to view \(self.newProposals.count) new proposals", for: .normal)
                cnt_viewMore.constant = 50
            } else {
                cnt_viewMore.constant = 0
            }
        }
    }
    var post: Post? {
        didSet {
            if let post = post {
                // Do any additional setup after loading the view.
                print(post.id)
                BidData.getListByPostId(postId: post.id) { (proposals) in
                    self.totalProposals = proposals
                }
            }
        }
    }
    @IBAction func actionViewMoreProposals(_ sender: Any) {
        self.totalProposals = self.totalProposals + self.newProposals
        self.newProposals = []
    }
    
    @IBOutlet weak var lbl_averageBid: UILabel!
    var totalProposals: [BidData] = [] {
        didSet {
            changedTotalProposals()
        }
    }
    
    var awardProposals: [BidData] = []
    var proposals: [BidData] = []
    
    func changedTotalProposals() {
        self.proposals = []
        self.awardProposals = []
        for proposal in totalProposals {
            if proposal.state == PostState.opened { // new bid
                self.proposals.append(proposal)
            } else {
                self.awardProposals.append(proposal)
            }
        }
        self.cnt_awardHeight.constant = CGFloat((self.awardProposals.count) * (150 + 40) + 2) - 40
        self.cnt_proposalHeight.constant = CGFloat((self.proposals.count ) * (150 + 40) + 2) - 40
        
        self.refresh()
    }
    
    func refresh() {
        var total_price: Float = 0
        var avg_price: Float = 0
        for proposal in totalProposals {
            total_price = total_price + proposal.bidPrice
        }
        avg_price = Float(total_price / Float(totalProposals.count))
        if totalProposals.count == 0 {
            lbl_averageBid.text = "0 bid"
        } else {
            lbl_averageBid.text = "\(String.currencyFormat(price: avg_price, unit: post?.priceUnit.symbol, decimal: 2)) / \(totalProposals.count) bids"
        }
        
        self.clv_awardedSellers.reloadData()
        self.clv_otherProposals.reloadData()
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


extension PostProposalsController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clv_awardedSellers {
            return self.awardProposals.count
        } else {
            return self.proposals.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.clv_awardedSellers {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProposalCell", for: indexPath) as! PostProposalCell
            cell.bid = awardProposals[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProposalCell2", for: indexPath) as! PostProposalCell
            cell.viewController = self
            cell.bid = proposals[indexPath.item]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class PostProposalCell: BaseCell {
    @IBOutlet weak var v_productImageWrapper: MyBaseView!
    @IBOutlet weak var iv_productImage: ProductImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var start_rating: HCSStarRatingView!
    @IBOutlet weak var lbl_reviewCount: UILabel!
    @IBOutlet weak var lbl_productDetail: UILabel!
//    @IBOutlet weak var lbl_realPrice: UILabel!
    @IBOutlet weak var lbl_bidPrice: UILabel!
    @IBOutlet weak var lbl_sellerName: UILabel!
    @IBOutlet weak var lbl_productState: UILabel!
    @IBOutlet weak var btn_addCart: BaseButton!
    
    var viewController: PostProposalsController?
    
    var bid: BidData? {
        didSet {
            if let product = bid?.product {
                iv_productImage.fromURL(urlString: product.url)
                lbl_productName.text = product.name
                lbl_rating.text = product.rate.toString(toFixed: 1)
                lbl_rating.layer.cornerRadius = 4
                lbl_rating.layer.masksToBounds = true
                start_rating.value = CGFloat(product.rate)
                lbl_reviewCount.text = String(product.reviewCount) + " reviews"
                lbl_productDetail.text = product.detail
//                lbl_realPrice.text = String.currencyFormat(price: product.price, unit: product.priceUnit.symbol, decimal: 2)
                lbl_bidPrice.text = String.currencyFormat(price: bid?.bidPrice ?? 0.0, unit: product.priceUnit.symbol, decimal: 2)
                lbl_sellerName.text = product.seller?.username
                if lbl_productState != nil {
                    lbl_productState.text = bid?.state
                }
                self.reshowViews()
            }
        }
    }
    
    
    func reshowViews() {
        if btn_addCart != nil {
            btn_addCart.isHidden = bid?.state != PostState.acceptted
        }
    }
    
    @IBAction func actionAward(_ sender: Any) {
        bid?.actionAward()
    }
    @IBAction func actionAddCart(_ sender: Any) {
        let index = StoreCart.shared.cart.firstIndex { (_bid) -> Bool in
            return _bid.id == bid?.id
        }
        if index == nil {
            StoreCart.shared.cart.append(bid!)
            self.btn_addCart.setTitle("Remove from cart", for: .normal)
        } else {
            StoreCart.shared.cart.remove(at: index!)
            self.btn_addCart.setTitle("Add to cart", for: .normal)
        }
    }
    @IBAction func actionRevoke(_ sender: Any) {
    }
    
}
