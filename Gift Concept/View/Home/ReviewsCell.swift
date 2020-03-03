//
//  ReviewsCell.swift
//  GIFT_APP
//
//  Created by Alguz on 11/4/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewsCell: BaseCell {
    @IBOutlet weak var iv_avatar: AvatarImageView!
    @IBOutlet weak var lbl_author_name: UILabel!
    @IBOutlet weak var lbl_createdAt: UILabel!
    @IBOutlet weak var lbl_rate: UILabel!
    @IBOutlet weak var rating_bar: HCSStarRatingView!
    @IBOutlet weak var lbl_content: UILabel!
    
    override func setupViews() {
        super.setupViews()
    }
    
    var data: Review! {
        didSet {
            lbl_author_name.text = data.owner?.displayName
            lbl_createdAt.text = data.createdAt
            lbl_rate.text = String(data.rate) + " / 5.0"
            rating_bar.value = CGFloat(data.rate)
            lbl_content.text = data.content
            if let avatarURL = data.owner?.photoURL {
                iv_avatar.fromURL(urlString: avatarURL)
            }
        }
    }
}
