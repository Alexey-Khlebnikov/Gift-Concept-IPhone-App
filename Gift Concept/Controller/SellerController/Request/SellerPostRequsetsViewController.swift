//
//  PostRequsetsViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/5/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class SellerPostRequsetsViewController: BaseViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btn_showMorePosts: BaseButton!
    @IBOutlet weak var cnt_showMorePosts: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StoreSellerPost.postRequestsViewController = self
        refreshShowMore()
        loadData()
        // Do any additional setup after loading the view.
        SocketIOApi.shared.socket.on("newPost") { (arguments, ack) in
            let post = Post(arguments[0] as! [String: AnyObject])
            DispatchQueue.main.async {
                self.morePosts.insert(post, at: 0)
                self.refreshShowMore()
            }
        }
        
        SocketIOApi.shared.socket.on("newSellProposal") { (arguments, ack) in
            let bidData = BidData(arguments[0] as! [String: AnyObject])
                if let firstIndex = self.postData.firstIndex(where: { (post) -> Bool in
                    return post.id == bidData.postId
                }) {
                    if firstIndex >= 0 || firstIndex < self.postData.count {
                        let post = self.postData[firstIndex]
                        post.bidIds.append(bidData.id)
                        post.sellerIds.append(bidData.userId)
                        let indexPath = IndexPath(item: firstIndex, section: 0)
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }
        }
    }
    
    func loadData() {
        Post.find { (posts) in
            self.postData = posts
            self.collectionView.reloadData()
        }
    }
    
    var postData: [Post] = []
    var morePosts: [Post] = []
    
    func refreshShowMore() {
        if self.morePosts.count > 0 {
            btn_showMorePosts.setTitle("Click to view \(self.morePosts.count) new posts", for: .normal)
            cnt_showMorePosts.constant = 50
        } else {
            cnt_showMorePosts.constant = 0
        }
    }
    
    @IBAction func actionShowMore(_ sender: Any) {
        if morePosts.count == 0 {
            return
        }
        cnt_showMorePosts.constant = 0
        
        postData = morePosts + postData
        morePosts = []
        
        self.collectionView.reloadData()
    }
    
    private var isDragging = false
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.isDragging = true
        } else {
            self.isDragging = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isFirstResponder {
            print("refresh event")
        }
         self.isDragging = false
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.isDragging {
            let post = postData[indexPath.item]
            if !post.isBided {
                self.performSegue(withIdentifier: "SellerCreateProposalViewSegue", sender: post)
            } else {
                self.performSegue(withIdentifier: "PostListToBiddedPostDetail", sender: post.id)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.isDragging = false
        let cell = collectionView.cellForItem(at: indexPath) as! SellerPostViewCell
        cell.setHightlightedColor()
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SellerPostViewCell
        cell.setDefaultColor()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SellerCreateProposalViewSegue" {
            let vc = segue.destination as! SellerPostDetailViewController
            vc.postData = sender as? Post
        } else if segue.identifier == "PostListToBiddedPostDetail" {
            let vc = segue.destination as! SellerOrdersContainerViewController
            vc.postId = sender as! String
        }
    }

    
}

extension SellerPostRequsetsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerPostViewCell", for: indexPath) as! SellerPostViewCell
        cell.setDefaultColor()
        cell.viewController = self
        cell.maxWidth = collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        cell.postData = self.postData[indexPath.item]
        
        return cell
    }
    
}

class SellerPostViewCell: AutoHeightCollectionViewCell {
    
    var postData: Post? {
        didSet {
            guard let postData = postData else {
                return
            }
            lbl_name.text = postData.name
            lbl_content.text = postData.content
            lbl_numberOfSellers.text = String(postData.bidIds.count) + " Sellers"
            lbl_priceRange.text = postData.rangePrice()
            lbl_createAt.text = postData.createAt.elapsedTime
            if postData.isBided {
                lbl_bidState.text = "You already bidded"
            } else {
                lbl_bidState.text = ""
            }
        }
    }
    
    func setDefaultColor() {
        backgroundColor = .white
        lbl_name.textColor = .black
        lbl_priceRange.textColor = .black
        lbl_content.textColor = .darkGray
        lbl_numberOfSellers.textColor = .darkGray
        lbl_createAt.textColor = .lightGray
        lbl_bidState.textColor = .systemGreen
    }
    func setHightlightedColor() {
        backgroundColor = .mainColor1
        lbl_name.textColor = .white
        lbl_priceRange.textColor = .white
        lbl_content.textColor = .lightText
        lbl_numberOfSellers.textColor = .systemGray4
        lbl_createAt.textColor = .systemGray5
        lbl_bidState.textColor = .darkText
    }
    
    @IBOutlet weak var lbl_content: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_numberOfSellers: UILabel!
    @IBOutlet weak var lbl_priceRange: UILabel!
    @IBOutlet weak var lbl_createAt: UILabel!
    @IBOutlet weak var lbl_bidState: UILabel!
    
}
