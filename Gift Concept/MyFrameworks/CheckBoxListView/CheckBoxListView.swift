//
//  CheckBoxListView.swift
//  GIFT_APP
//
//  Created by Alguz on 12/7/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

@IBDesignable class CheckBoxListView: MyBaseView {
    
    @IBInspectable var checkedIcon: UIImage? = UIImage(systemName: "checkmark.square")?.withRenderingMode(.alwaysTemplate) {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable var uncheckedIcon: UIImage? = UIImage(systemName: "square")?.withRenderingMode(.alwaysTemplate) {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable var checkedColor: UIColor = .black {
        didSet {
            refresh()
        }
    }
    
    func refresh() {
        DispatchQueue.main.async {
            return self.collectionView.reloadData()
        }
    }
    
    @IBInspectable var uncheckedColor: UIColor = .black {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable var checkedFontSize: CGFloat = 15 {
        didSet {
            refresh()
        }
    }
    @IBInspectable var uncheckedFontSize: CGFloat = 14 {
        didSet {
            refresh()
        }
    }
    
    var items: [String] = ["One", "Two", "Three"] {
        didSet {
            self.itemsCheckedState = self.items.map({_ in return false})
        }
    }
    
    var itemsCheckedState: [Bool] = [false, false, true] {
       didSet {
           refresh()
       }
   }
    
    let layout = UICollectionViewFlowLayout()
    
    var isDragging: Bool = false
    
    var delegate: CheckBoxListViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    override func setupViews() {
        super.setupViews()
        collectionView.backgroundColor = .clear
        collectionView.register(CheckBoxListCell.self, forCellWithReuseIdentifier: "CheckBoxListCell")
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
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
         self.isDragging = false
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.isDragging {
            let cell = collectionView.cellForItem(at: indexPath) as! CheckBoxListCell
            cell.isChecked = !cell.isChecked
            itemsCheckedState[indexPath.item] = cell.isChecked
            delegate?.changeValues()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.isDragging = false
    }
}

extension CheckBoxListView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckBoxListCell", for: indexPath) as! CheckBoxListCell
        cell.checkedIcon = checkedIcon
        cell.uncheckedIcon = uncheckedIcon
        cell.checkedColor = checkedColor
        cell.uncheckedColor = uncheckedColor
        cell.checkedFontSize = checkedFontSize
        cell.uncheckedFontSize = uncheckedFontSize
        cell.label.text = items[indexPath.item]
        if indexPath.item < itemsCheckedState.count {
            cell.isChecked = itemsCheckedState[indexPath.item]
        } else {
            cell.isChecked = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: checkedFontSize)
    }
    
}


