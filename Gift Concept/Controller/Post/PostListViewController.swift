//
//  PostListViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/27/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {
    @IBOutlet weak var clv_layout: UICollectionViewFlowLayout! {
        didSet {
            clv_layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myPosts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var socketEventIds: [UUID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedViewControllers.postListViewController = self
        loadMyPosts()
        // Do any additional setup after loading the view.
        
        let uuid = SocketIOApi.shared.socket.on("newPost") { (arguments, ack) in
            let post = Post(arguments[0] as! [String: AnyObject])
            DispatchQueue.main.async {
                self.myPosts.insert(post, at: 0)
            }
        }
        socketEventIds.append(uuid)
    }
    
    func loadMyPosts() {
        Post.findByBuyer(complete: { (posts) in
            self.myPosts = posts
        })
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

extension PostListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostListViewItemCell", for: indexPath) as! PostListViewItemCell
        
        cell.postData = myPosts[indexPath.item]
        
        cell.maxWidth = collectionView.frame.width - 40
        
        cell.viewController = self.parent
        
        return cell
    }
    
}


class PostListViewItemCell: UICollectionViewCell {
    var viewController: UIViewController?
    var postData: Post? {
        didSet {
            lbl_name.text = postData?.name
            lbl_detail.text = postData?.content
            lbl_sellerCount.text = String(postData?.bidIds.count ?? 0) + " Sellers"
            lbl_priceRange.text = postData?.rangePrice()
            lbl_createdAgo.text = Date().elapsedTime
        }
    }
    @IBOutlet weak var cnt_width: NSLayoutConstraint!
    
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            cnt_width.constant = maxWidth
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    var stateColor: UIColor? {
        didSet {
            v_stateWrapper.layer.borderColor = stateColor?.cgColor
            lbl_state.textColor = stateColor
        }
    }
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_detail: UILabel!
    @IBOutlet weak var lbl_sellerCount: UILabel!
    @IBOutlet weak var lbl_priceRange: UILabel!
    
    
    @IBOutlet weak var v_stateWrapper: MyBaseView!
    @IBOutlet weak var lbl_state: UILabel!
    @IBOutlet weak var lbl_createdAgo: UILabel!
    
    
    @IBAction func gotoDetail(_ sender: Any) {
        viewController?.performSegue(withIdentifier: "PostDetailViewController", sender: postData)
    }
}
