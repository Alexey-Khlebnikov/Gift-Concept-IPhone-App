//
//  MenuBar.swift
//  gift_app
//
//  Created by Lexy on 8/8/19.
//  Copyright © 2019 Lexy. All rights reserved.
//

import UIKit

class MenuBar: MyBaseView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var homeController: HomeController?
    var selectedIndex = 0
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(red: 233, green: 32, blue: 126)
        
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
//
//    let cart: ImageViewWarpper = {
//        let iv = ImageViewWarpper()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.imageView.image = UIImage(named: "icon_Cart")?.withAlignmentRectInsets(UIEdgeInsets(top: -13, left: -10, bottom: -10, right: -10)).withRenderingMode(.alwaysTemplate)
//        iv.tintColor = .white
//
//        iv.layer.cornerRadius = 30
//        iv.clipsToBounds = true
//        iv.backgroundColor = UIColor(red: 233, green: 32, blue: 126)
//
//        return iv
//    }()
//
    let cellId = "cellId"
    let imageNames = ["Home", "Bill", "", "Notification", "More"]
    
    
    override func setupViews() {
        super.setupViews()
        addSubview(collectionView)
        setupHorizontalBar()
//        addSubview(cart)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delaysContentTouches = false
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        
//        addConstraintsWithFormat(format: "H:[v0(60)]", views: cart)
//        addConstraintsWithFormat(format: "V:[v0(60)]", views: cart)
//        addConstraint(NSLayoutConstraint(item: cart, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: cart, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -30))
        
        
        shadow(left: 0, top: -1.0, feather: 3, color: .black, opacity: 0.5)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        
        
    }
    
    
    var horizontalConstraintLeftAnchor: NSLayoutConstraint?
    func setupHorizontalBar() {
        let horizontalView = UIView()
        horizontalView.translatesAutoresizingMaskIntoConstraints = false
        horizontalView.backgroundColor = .white
        addSubview(horizontalView)
        
        horizontalConstraintLeftAnchor = horizontalView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalConstraintLeftAnchor?.isActive = true
        horizontalView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizontalView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(1) / CGFloat(imageNames.count)).isActive = true
        horizontalView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        complexShape()
    }
    
    var path: UIBezierPath!
    let circle_radius: CGFloat = 30
    let distance: CGFloat = 3

    private func complexShape() {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = collectionView.frame.height
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width / 2 - circle_radius - distance, y: 0))
        
        path.addArc(withCenter: CGPoint(x: width / 2, y: 0), radius: circle_radius + distance, startAngle: CGFloat(180).toRadians(), endAngle: CGFloat(360).toRadians(), clockwise: false)
        
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))

        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath

        collectionView.layer.mask = shapeLayer
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
//    var isFrist: Bool = true
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: "icon_" + imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.parent? = self
        if indexPath.item == selectedIndex {
            cell.imageView.tintColor = UIColor.white
        }
        if indexPath.item == 2 {
            cell.enable = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 5, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    var shouldSelectItem:MenuCell?
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as? MenuCell
        shouldSelectItem = cell
        return cell!.enable
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return shouldSelectItem!.enable
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let left = CGFloat(indexPath.item) * frame.width / CGFloat(imageNames.count)
//        horizontalConstraintLeftAnchor?.constant = left
//        let cell = collectionView.cellForItem(at: indexPath) as? MenuCell
//        cell?.imageView.tintColor = UIColor.white
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        let item = indexPath.item > 1 ? indexPath.item - 1 : indexPath.item
//        homeController?.setTitle(index: item)
        homeController?.scrollToMenuIndex(menuIndex: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MenuCell
        cell?.imageView.tintColor = UIColor(red: 91, green: 14, blue: 13)
    }
    
}


class MenuCell: BaseCell {
    var enable: Bool = true
    var parent: MenuBar?

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor(red: 91, green: 14, blue: 13)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.font = lb.font.withSize(14)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    

    override var isHighlighted: Bool {
        didSet{
            if enable {
                if self.isHighlighted {
                    self.imageView.tintColor = UIColor.white
                } else {
                    self.imageView.tintColor = UIColor(red: 91, green: 14, blue: 13)
                }
            }
        }
    }

    override var isSelected: Bool {
        didSet{
            if enable {
                if self.isSelected {
                    self.imageView.tintColor = UIColor.white
                } else {
                    self.imageView.tintColor = UIColor(red: 91, green: 14, blue: 13)
                }
            }
        }
    }

    override func setupViews() {
        super.setupViews()

        addSubview(imageView)
//        addSubview(label)

        addConstraintsWithFormat(format: "H:[v0(25)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(25)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

//        addConstraintsWithFormat(format: "V:[v0(20)]", views: label)
//        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 3))

    }
}

class ImageViewWarpper: MyBaseView{

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "icon_Cart")
        return iv
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
    }
    
}
