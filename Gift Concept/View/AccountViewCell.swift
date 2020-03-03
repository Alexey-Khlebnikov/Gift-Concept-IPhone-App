//
//  AccountViewCell.swift
//  GIFT_APP
//
//  Created by Alguz on 11/1/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import UIKit


class AccountViewCell: BaseCell {
    var viewController: HomeController! {
        didSet {
            
        }
    }
    
    var AccountData: Account! {
        didSet {
            
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .mainBgColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let avatarView: AvatarImageView = {
        let urlImageView = AvatarImageView()
        urlImageView.fromURL(urlString: "girl.png")
        urlImageView.translatesAutoresizingMaskIntoConstraints = false
        return urlImageView
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(30)
        label.shadow(left: 0, top: 3, feather: 6, color: .black, opacity: 0.15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let featuredView: LabelView = {
        let label = LabelView()
        label.font = label.font.withSize(16)
        label.textColor = .darkGray
        label.text = "I have worked with multiple freelancers in the past, but none were able to deliver work like jxcreations. They have topped all work and commitment I have ever encountered. The team is very experienced and almost no guidance was needed. Communication was never lost and they were very responsive throughout the project. I would definitely recommend jxcreations to fellow peers and acquaintances. I will reach out to them again in the near future for modifications/adjustments."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lbl_email: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lbl_phone: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lbl_open_count: UILabel = {
        let lbl_open_count = UILabel()
        lbl_open_count.textColor = .mainColor1
        lbl_open_count.translatesAutoresizingMaskIntoConstraints = false
        return lbl_open_count
    }()
    
    let lbl_active_count: UILabel = {
        let lbl_active_count = UILabel()
        lbl_active_count.textColor = .mainColor1
        lbl_active_count.translatesAutoresizingMaskIntoConstraints = false
        return lbl_active_count
    }()
    
    let lbl_past_count: UILabel = {
        let lbl_past_count = UILabel()
        lbl_past_count.textColor = .mainColor1
        lbl_past_count.translatesAutoresizingMaskIntoConstraints = false
        return lbl_past_count
    }()
    
    let lbl_refund_count: UILabel = {
        let lbl_refund_count = UILabel()
        lbl_refund_count.textColor = .mainColor1
        lbl_refund_count.translatesAutoresizingMaskIntoConstraints = false
        return lbl_refund_count
    }()
    
    let lbl_preparingCount = UILabel()
    let lbl_shippedCount = UILabel()
    let lbl_deliveredCount = UILabel()

    
    override func setupViews() {
        super.setupViews()
        addSubview(scrollView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
        
        scrollView.addSubview(avatarView)
        
        setupComponents()
        loadUserData()
    }
    
    func loadUserData() {
        username.text = "Ammy Jahnson"
        lbl_email.text = "odcruningodc@gmail.com"
        lbl_phone.text = "9873847584749"
        lbl_open_count.text = "23"
        lbl_active_count.text = "36"
        lbl_past_count.text = "12"
        lbl_refund_count.text = "43"
        lbl_preparingCount.text = "23"
        lbl_shippedCount.text = "13"
        lbl_deliveredCount.text = "12"
    }
    
    func setupComponents() {
        avatarView.widthAnchor.constraint(equalToConstant: 178).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 178).isActive = true
        avatarView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        avatarView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        
        scrollView.addSubview(username)
        username.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20).isActive = true
        username.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        let containerView1 = UIView()
        containerView1.layer.cornerRadius = 10
        containerView1.layer.masksToBounds = true
        containerView1.backgroundColor = .secondBgColor
        containerView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView1)
        containerView1.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 30).isActive = true
        containerView1.heightAnchor.constraint(equalToConstant: 120).isActive = true
        containerView1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        containerView1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "Featured Review"
        label1.font = label1.font.withSize(20)
        containerView1.addSubview(label1)
        label1.topAnchor.constraint(equalTo: containerView1.topAnchor, constant: 10).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label1.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 20).isActive = true
        label1.trailingAnchor.constraint(equalTo: containerView1.trailingAnchor, constant: -20).isActive = true

        containerView1.addSubview(featuredView)
        featuredView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0).isActive = true
        featuredView.bottomAnchor.constraint(equalTo: containerView1.bottomAnchor, constant: -10).isActive = true
        featuredView.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 20).isActive = true
        featuredView.trailingAnchor.constraint(equalTo: containerView1.trailingAnchor, constant: -20).isActive = true
        
        
        // MARK: - Request Information

        scrollView.addSubview(lbl_open_count)
        
        let lbl_open_label = UILabel()
        lbl_open_label.text = "Open"
        lbl_open_label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(lbl_open_label)
        
        scrollView.addSubview(lbl_active_count)
        
        let lbl_active_label = UILabel()
        lbl_active_label.text = "Active"
        lbl_active_label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(lbl_active_label)
        
        lbl_open_count.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 30).isActive = true
        lbl_open_count.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lbl_open_label.leadingAnchor.constraint(equalTo: lbl_open_count.trailingAnchor, constant: 10).isActive = true
        lbl_open_label.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 0.5, constant: -90).isActive = true
        lbl_active_count.leadingAnchor.constraint(equalTo: lbl_open_label.trailingAnchor, constant: 0).isActive = true
        lbl_active_count.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lbl_active_label.leadingAnchor.constraint(equalTo: lbl_active_count.trailingAnchor, constant: 10).isActive = true
        lbl_active_label.rightAnchor.constraint(equalTo: containerView1.rightAnchor).isActive = true
        
        lbl_open_count.topAnchor.constraint(equalTo: containerView1.bottomAnchor, constant: 20).isActive = true
        lbl_open_count.heightAnchor.constraint(equalToConstant: 16).isActive = true
        lbl_open_label.bottomAnchor.constraint(equalTo: lbl_open_count.bottomAnchor).isActive = true
        lbl_active_count.bottomAnchor.constraint(equalTo: lbl_open_count.bottomAnchor).isActive = true
        lbl_active_label.bottomAnchor.constraint(equalTo: lbl_open_count.bottomAnchor).isActive = true
        
        
        scrollView.addSubview(lbl_past_count)
        
        let lbl_past_label = UILabel()
        lbl_past_label.text = "Past"
        lbl_past_label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(lbl_past_label)
        
        scrollView.addSubview(lbl_refund_count)
        
        let lbl_refund_label = UILabel()
        lbl_refund_label.text = "Refund"
        lbl_refund_label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(lbl_refund_label)
        
        lbl_past_count.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 30).isActive = true
        lbl_past_count.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lbl_past_label.leadingAnchor.constraint(equalTo: lbl_past_count.trailingAnchor, constant: 10).isActive = true
        lbl_past_label.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 0.5, constant: -90).isActive = true
        lbl_refund_count.leadingAnchor.constraint(equalTo: lbl_past_label.trailingAnchor, constant: 0).isActive = true
        lbl_refund_count.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lbl_refund_label.leadingAnchor.constraint(equalTo: lbl_refund_count.trailingAnchor, constant: 10).isActive = true
        lbl_refund_label.rightAnchor.constraint(equalTo: containerView1.rightAnchor).isActive = true
        
        lbl_past_count.topAnchor.constraint(equalTo: lbl_open_count.bottomAnchor, constant: 10).isActive = true
        lbl_past_count.heightAnchor.constraint(equalToConstant: 16).isActive = true
        lbl_past_label.bottomAnchor.constraint(equalTo: lbl_past_count.bottomAnchor).isActive = true
        lbl_refund_count.bottomAnchor.constraint(equalTo: lbl_past_count.bottomAnchor).isActive = true
        lbl_refund_label.bottomAnchor.constraint(equalTo: lbl_past_count.bottomAnchor).isActive = true
        
        
        // MARK: - Contact Information
        let lbl_contact_label = UILabel()
        lbl_contact_label.translatesAutoresizingMaskIntoConstraints = false
        lbl_contact_label.text = "Contact Information"
        lbl_contact_label.font = lbl_contact_label.font.withSize(20)
        scrollView.addSubview(lbl_contact_label)
        lbl_contact_label.topAnchor.constraint(equalTo: lbl_past_count.bottomAnchor, constant: 30).isActive = true
        lbl_contact_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        lbl_contact_label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        
        let lbl_emailLabel = UILabel()
        lbl_emailLabel.translatesAutoresizingMaskIntoConstraints = false
        lbl_emailLabel.text = "Email"
        lbl_emailLabel.font = lbl_emailLabel.font.withSize(16)
        lbl_emailLabel.textColor = .gray
        scrollView.addSubview(lbl_emailLabel)
        scrollView.addSubview(lbl_email)
        
        scrollView.addConstraintsWithFormat(format: "H:|-50-[v0(60)]-10-[v1]-20-|", views: lbl_emailLabel, lbl_email)
        lbl_emailLabel.topAnchor.constraint(equalTo: lbl_contact_label.bottomAnchor, constant: 15).isActive = true
        lbl_email.bottomAnchor.constraint(equalTo: lbl_emailLabel.bottomAnchor).isActive = true
        
        let lbl_phoneLabel = UILabel()
        lbl_phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        lbl_phoneLabel.text = "Phone"
        lbl_phoneLabel.font = lbl_phoneLabel.font.withSize(16)
        lbl_phoneLabel.textColor = .gray
        scrollView.addSubview(lbl_phoneLabel)
        scrollView.addSubview(lbl_phone)
        
        scrollView.addConstraintsWithFormat(format: "H:|-50-[v0(60)]-10-[v1]-20-|", views: lbl_phoneLabel, lbl_phone)
        lbl_phoneLabel.topAnchor.constraint(equalTo: lbl_emailLabel.bottomAnchor, constant: 15).isActive = true
        lbl_phone.bottomAnchor.constraint(equalTo: lbl_phoneLabel.bottomAnchor).isActive = true
        
        
        // MARK: - Order Information
        let lbl_ordersLabel = UILabel()
        lbl_ordersLabel.translatesAutoresizingMaskIntoConstraints = false
        lbl_ordersLabel.text = "Orders"
        lbl_ordersLabel.font = lbl_ordersLabel.font.withSize(20)
        scrollView.addSubview(lbl_ordersLabel)
        
        lbl_ordersLabel.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 20).isActive = true
        lbl_ordersLabel.topAnchor.constraint(equalTo: lbl_phoneLabel.bottomAnchor, constant: 20).isActive = true
        lbl_ordersLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        lbl_preparingCount.translatesAutoresizingMaskIntoConstraints = false
        lbl_preparingCount.font = lbl_preparingCount.font.withSize(26)
        scrollView.addSubview(lbl_preparingCount)
        lbl_preparingCount.textAlignment = .center
        lbl_preparingCount.topAnchor.constraint(equalTo: lbl_ordersLabel.bottomAnchor, constant: 70).isActive = true
        lbl_preparingCount.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 1 / 3, constant: 0).isActive = true
        lbl_preparingCount.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor).isActive = true
        
        
        lbl_shippedCount.translatesAutoresizingMaskIntoConstraints = false
        lbl_shippedCount.textAlignment = .center
        lbl_shippedCount.font = lbl_shippedCount.font.withSize(26)
        scrollView.addSubview(lbl_shippedCount)
        lbl_shippedCount.topAnchor.constraint(equalTo: lbl_preparingCount.topAnchor).isActive = true
        lbl_shippedCount.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 1 / 3, constant: 0).isActive = true
        lbl_shippedCount.leadingAnchor.constraint(equalTo: lbl_preparingCount.trailingAnchor).isActive = true
        
        
        lbl_deliveredCount.translatesAutoresizingMaskIntoConstraints = false
        lbl_deliveredCount.textAlignment = .center
        lbl_deliveredCount.font = lbl_deliveredCount.font.withSize(26)
        scrollView.addSubview(lbl_deliveredCount)
        lbl_deliveredCount.topAnchor.constraint(equalTo: lbl_preparingCount.topAnchor).isActive = true
        lbl_deliveredCount.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 1 / 3, constant: 0).isActive = true
        lbl_deliveredCount.leadingAnchor.constraint(equalTo: lbl_shippedCount.trailingAnchor).isActive = true
        
        
        let lbl_preparingLabel = UILabel()
        lbl_preparingLabel.translatesAutoresizingMaskIntoConstraints = false
        lbl_preparingLabel.text = "Preparing"
        lbl_preparingLabel.font = lbl_preparingLabel.font.withSize(14)
        scrollView.addSubview(lbl_preparingLabel)
        lbl_preparingLabel.textAlignment = .center
        lbl_preparingLabel.topAnchor.constraint(equalTo: lbl_ordersLabel.bottomAnchor, constant: 100).isActive = true
        lbl_preparingLabel.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 1 / 3, constant: 0).isActive = true
        lbl_preparingLabel.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor).isActive = true
        
        let lbl_shipped = UILabel()
        lbl_shipped.translatesAutoresizingMaskIntoConstraints = false
        lbl_shipped.text = "Shipped"
        lbl_shipped.textAlignment = .center
        lbl_shipped.font = lbl_shipped.font.withSize(14)
        scrollView.addSubview(lbl_shipped)
        lbl_shipped.topAnchor.constraint(equalTo: lbl_preparingLabel.topAnchor).isActive = true
        lbl_shipped.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 1 / 3, constant: 0).isActive = true
        lbl_shipped.leadingAnchor.constraint(equalTo: lbl_preparingLabel.trailingAnchor).isActive = true
        
        let lbl_delivered = UILabel()
        lbl_delivered.translatesAutoresizingMaskIntoConstraints = false
        lbl_delivered.text = "Delivered"
        lbl_delivered.textAlignment = .center
        lbl_delivered.font = lbl_delivered.font.withSize(14)
        scrollView.addSubview(lbl_delivered)
        lbl_delivered.topAnchor.constraint(equalTo: lbl_preparingLabel.topAnchor).isActive = true
        lbl_delivered.widthAnchor.constraint(equalTo: containerView1.widthAnchor, multiplier: 1 / 3, constant: 0).isActive = true
        lbl_delivered.leadingAnchor.constraint(equalTo: lbl_shipped.trailingAnchor).isActive = true
        
        
        
        
        
        let iv_prepareing = UIImageView()
        iv_prepareing.tintColor = .mainColor1
        iv_prepareing.translatesAutoresizingMaskIntoConstraints = false
        iv_prepareing.image = UIImage(named: "product_50")?.withRenderingMode(.alwaysTemplate)
        iv_prepareing.contentMode = .scaleAspectFit
        scrollView.addSubview(iv_prepareing)
        
        
        let iv_shipped = UIImageView()
        iv_shipped.tintColor = .mainColor1
        iv_shipped.translatesAutoresizingMaskIntoConstraints = false
        iv_shipped.image = UIImage(named: "car_check_50")?.withRenderingMode(.alwaysTemplate)
        iv_shipped.contentMode = .scaleAspectFit
        scrollView.addSubview(iv_shipped)
        
        
        let iv_delivered = UIImageView()
        iv_delivered.tintColor = .mainColor1
        iv_delivered.translatesAutoresizingMaskIntoConstraints = false
        iv_delivered.image = UIImage(named: "handshake_50")?.withRenderingMode(.alwaysTemplate)
        iv_delivered.contentMode = .scaleAspectFit
        scrollView.addSubview(iv_delivered)
        
        iv_prepareing.centerXAnchor.constraint(equalTo: lbl_preparingLabel.centerXAnchor).isActive = true
        iv_shipped.centerXAnchor.constraint(equalTo: lbl_shipped.centerXAnchor).isActive = true
        iv_delivered.centerXAnchor.constraint(equalTo: lbl_delivered.centerXAnchor).isActive = true
        
        iv_prepareing.topAnchor.constraint(equalTo: lbl_ordersLabel.bottomAnchor, constant: 20).isActive = true
        iv_prepareing.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv_shipped.topAnchor.constraint(equalTo: iv_prepareing.topAnchor).isActive = true
        iv_shipped.heightAnchor.constraint(equalTo: iv_prepareing.heightAnchor).isActive = true
        iv_delivered.topAnchor.constraint(equalTo: iv_prepareing.topAnchor).isActive = true
        iv_delivered.heightAnchor.constraint(equalTo: iv_prepareing.heightAnchor).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: lbl_preparingLabel.bottomAnchor, constant: 20).isActive = true
    }
    
}
