//
//  CollectionTabViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/4/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

protocol CollectionStoryboardViewDelegate {
    func getStoryboardInfoList() -> [(storyboard: String, identifier: String)]
    func storyboardViewWillEndDraging(index: Int)
    func senderList() -> [Any?]
}

class CollectionStoryboardViewController: BaseViewController {
    
    var delegate: CollectionStoryboardViewDelegate?
    
    private var storyboardInfoList:[(storyboard: String, identifier: String)] {
        get {
            return delegate?.getStoryboardInfoList() ?? []
        }
    }
    func getSender(_ index: Int) -> Any? {
        let list = delegate?.senderList() ?? []
        if index >= list.count {
            return nil
        }
        return list[index]
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        for storyboardInfo in storyboardInfoList {
            collectionView.register(CollectionStoryboardViewCell.self, forCellWithReuseIdentifier: storyboardInfo.identifier)
        }

        // Do any additional setup after loading the view.
    }
    
    var initSelectedTabIndex: Int = 0
    
    func scrollToMenuIndex(index: Int) {
        guard isViewLoaded else {
            initSelectedTabIndex = index
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        delegate?.storyboardViewWillEndDraging(index: index)
    }
    
    func setTitle(_ title: String?) {
        navigationItem.title = title
    }
}

extension CollectionStoryboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyboardInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let storyboardInfo = storyboardInfoList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyboardInfo.identifier, for: indexPath) as! CollectionStoryboardViewCell
        cell.sender = getSender(indexPath.item)
        cell.storyboardInfo = storyboardInfo
        cell.viewController = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInset = layout.sectionInset
        
        let width = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let height = collectionView.bounds.height - sectionInset.top - sectionInset.bottom
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

 

