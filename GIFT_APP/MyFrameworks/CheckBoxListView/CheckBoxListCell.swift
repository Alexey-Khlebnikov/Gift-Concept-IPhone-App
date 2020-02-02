//
//  CheckBoxListCell.swift
//  GIFT_APP
//
//  Created by Alguz on 12/7/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

class CheckBoxListCell: BaseCell {
    var checkedIcon: UIImage?
    var uncheckedIcon: UIImage?
    
    var checkedColor: UIColor?
    var uncheckedColor: UIColor?
    
    var checkedFontSize: CGFloat = 15
    var uncheckedFontSize: CGFloat = 14
    
    var isChecked: Bool = false {
        didSet {
            refresh()
        }
    }
    
    var checkableIconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
        }() {
        didSet {
            refresh()
        }
    }
    
    var iconHeightConstraint: NSLayoutConstraint!
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        checkableIconView.image = uncheckedIcon
        addSubview(checkableIconView)
        addSubview(label)
        
        iconHeightConstraint = checkableIconView.heightAnchor.constraint(equalToConstant: 0)
        iconHeightConstraint.isActive = true
        
        checkableIconView.widthAnchor.constraint(equalTo: checkableIconView.heightAnchor, multiplier: 1).isActive = true
        checkableIconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        
        checkableIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        label.leadingAnchor.constraint(equalTo: checkableIconView.trailingAnchor, constant: 2).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        refresh()
    }
    
    func refresh() {
        if isChecked {
            iconHeightConstraint.constant = checkedFontSize
            checkableIconView.image = checkedIcon
            checkableIconView.tintColor = checkedColor
            label.font  = label.font.withSize(checkedFontSize)
            label.textColor = checkedColor
        } else {
            iconHeightConstraint.constant = uncheckedFontSize
            checkableIconView.image = uncheckedIcon
            checkableIconView.tintColor = uncheckedColor
            label.font  = label.font.withSize(uncheckedFontSize)
            label.textColor = uncheckedColor
        }
    }
}
