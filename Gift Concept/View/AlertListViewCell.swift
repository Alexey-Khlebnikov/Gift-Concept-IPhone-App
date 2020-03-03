//
//  AlertsCollectionViewCell.swift
//  GIFT_APP
//
//  Created by Alguz on 10/31/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import UIKit


class AlertListViewCell: BaseCell {

    var alertsData: [Alert] = [] {
        didSet {
            collectionView.refresh()
        }
    }
    
    var viewController: HomeController!

    lazy var collectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        
        collectionView.register(AlertListItemCell.self, forCellWithReuseIdentifier: "AlertListItemCell")
        
        collectionView.padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.numberOfItemsInSection = self.numberOfItemsInSection
        collectionView.cellForItemAt = self.cellForItemAt
        collectionView.direction = .vertical
        collectionView.cellSize = self.cellSize
        
        collectionView.shadow(left: 5, top: 5, feather: 15, color: .black, opacity: 0.1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        loadAlertsData()
        // Do any additional setup after loading the view.
    }

    func loadAlertsData() {
        alertsData = [Alert(), Alert(), Alert(),Alert(), Alert(), Alert(), Alert(), Alert(), Alert()]
    }

    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlertListItemCell", for: indexPath) as! AlertListItemCell
        cell.alert = alertsData[indexPath.item]
        return cell
    }

    func cellSize(index: Int) -> (Int, CGFloat) {
        return (1, 190)
    }

    func numberOfItemsInSection(collectionView: UICollectionView, section: Int) -> Int {
        return alertsData.count
    }

}


class AlertListItemCell: BaseCell {
    var alert: Alert? {
        didSet {
            refresh()
        }
    }
    let name: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let content: LabelView = {
        let label = LabelView()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let time: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .lightGray
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let option: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnViewDetail: UIButton =  {
        let button = UIButton()
        button.setTitle("More  >>", for: .normal)
        
        button.setTitleColor(.mainColor1, for: .normal)
        button.contentMode = .center
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .mainBgColor
        addSubview(name)
        addSubview(content)
        addSubview(time)
        addSubview(option)
        addSubview(btnViewDetail)
        
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: time)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: name)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: content)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-[v1(90)]-20-|", views: option, btnViewDetail)
        
        addConstraintsWithFormat(format: "V:|-10-[v0(14)]-10-[v1(25)]-15-[v2]-20-[v3(16)]-15-|", views: time, name, content, option)
        btnViewDetail.bottomAnchor.constraint(equalTo: option.bottomAnchor).isActive = true
        btnViewDetail.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func refresh() {
        name.text = alert?.name
        content.text = alert?.content
        time.text = alert?.time
        option.text = alert?.option
    }
}
