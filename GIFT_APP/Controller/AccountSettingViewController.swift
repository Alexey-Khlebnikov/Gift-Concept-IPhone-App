//
//  AccountSettingViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/1/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents

class AccountSettingViewController: UIViewController, CustomCollectionViewDelegate {
    func didSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfItemsInSection(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingTypes.count
    }
    
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountSettingCell", for: indexPath) as! AccountSettingCell
        cell.settingType = settingTypes[indexPath.item]
        return cell
    }
    
    func cellSize(index: Int) -> (groupCount: Int, itemSize: CGFloat) {
        return (1, 50)
    }
    

    lazy var collectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        collectionView.register(AccountSettingCell.self, forCellWithReuseIdentifier: "AccountSettingCell")
        collectionView.shadow(left: 0, top: 2, feather: 4, color: .black, opacity: 0.1)
        collectionView.cellSpacing = 4
        collectionView.direction = .vertical
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let settingTypes: [String] = ["Account & Security","Shipping Address","Leave feedback","Rate us","Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0]-\(bottomBarOffset())-|", views: collectionView)
        // Do any additional setup after loading the view.
        setupTopWrapper()
    }
    
    
    func setupViews() {
        
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

class AccountSettingCell: BaseCell {
    var settingType: String? {
        didSet {
            lbl_name.text = settingType
        }
    }
    let lbl_name: UILabel = {
        let lbl_name = UILabel()
        lbl_name.translatesAutoresizingMaskIntoConstraints = false
        return lbl_name
    }()
    let lbl_arrow: UILabel = {
        let lbl = UILabel()
        lbl.text = ">"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        addSubview(lbl_name)
        addSubview(lbl_arrow)
        
        addConstraintsWithFormat(format: "H:|-40-[v0]-0-[v1(10)]-40-|", views: lbl_name, lbl_arrow)
        lbl_name.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lbl_arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
