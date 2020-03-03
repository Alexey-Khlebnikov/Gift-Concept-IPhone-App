//
//  SellerDetailViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/13/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class SellerBidDetailViewController: BaseViewController {

    @IBOutlet weak var iv_product: ProductThumbImageView!
    @IBOutlet weak var btn_Accept: BaseButton!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var star_rating: RatingView!
    @IBOutlet weak var lbl_bidPrice: UILabel!
    @IBOutlet weak var lbl_productPrice: UILabel!
    @IBOutlet weak var lbl_productDetail: UILabel!
    @IBOutlet weak var lbl_bidState: UILabel!
    
    var bidData: BidData? {
        didSet {
            self.setupViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        BidData.getMyBidInPost(postId: sender as! String) { (bidData) in
            self.bidData = bidData
        }
    }
    
    func setupViews() {
        if let product = bidData?.product {
            iv_product.fromURL(urlString: product.url)
            lbl_productName.text = product.name
            star_rating.value = CGFloat(product.rate)
            lbl_bidPrice.text = product.getFullPrice(price: bidData!.bidPrice)
            lbl_productPrice.text = product.fullPrice
            lbl_productDetail.text = product.detail
        }
        refreshState()
    }
    
    override func setupSocket() {
        super.setupSocket()
        SocketIOApi.shared.socket.on("awardProposal") { (arguments, arc) in
            let bidId = arguments[0] as! String
            if let bidData = self.bidData {
                if bidData.id == bidId {
                    bidData.state = PostState.awaiting
                    self.refreshState()
                }
            }
        }
        SocketIOApi.shared.socket.on("acceptAward") { (arguments, arc) in
            let bidId = arguments[0] as! String
            if let bidData = self.bidData {
                if bidData.id == bidId {
                    bidData.state = PostState.acceptted
                    self.refreshState()
                }
            }
        }
        SocketIOApi.shared.socket.on("revokeProposal") { (arguments, arc) in
            let bidId = arguments[0] as! String
            let bidState = arguments[1] as! String
            if let bidData = self.bidData {
                if bidData.id == bidId {
                    bidData.state = bidState
                    self.refreshState()
                }
            }
        }
    }
    
    func refreshState() {
        btn_Accept.isHidden = bidData?.state != PostState.awaiting
        lbl_bidState.text = bidData?.state
        lbl_bidState.isHidden = !btn_Accept.isHidden
    }
    
    @IBAction func action_Accept(_ sender: Any) {
        bidData?.actionAccept()
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
