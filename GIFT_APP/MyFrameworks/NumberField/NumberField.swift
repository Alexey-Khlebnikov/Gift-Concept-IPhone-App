//
//  NumberField.swift
//  GIFT_APP
//
//  Created by Alguz on 1/23/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import Foundation
@IBDesignable class NumberField: MyBaseView {
    @IBInspectable var controlBg: UIColor = .lightGray {
        didSet {
            refreshView()
        }
    }
    @IBInspectable var controlFg: UIColor = .black {
        didSet {
            refreshView()
        }
    }
    @IBInspectable var controlFontSize: CGFloat = 25 {
        didSet {
            refreshView()
        }
    }
    @IBInspectable var color: UIColor = .black {
        didSet {
            refreshView()
        }
    }
    
    @IBInspectable var value: Int = 0 {
        didSet {
            refreshView()
        }
    }
    @IBInspectable var min: Int = 0 {
        didSet {
            refreshView()
        }
    }
    @IBInspectable var max: Int = 9999 {
        didSet {
            refreshView()
        }
    }
    
    let btn_minus: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("-", for: .normal)
        return btn
    }()
    let btn_plus: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("+", for: .normal)
        return btn
    }()
    let txt_input: UITextField = {
        let txt = UITextField()
        txt.isUserInteractionEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.borderStyle = .none
        txt.textContentType = .telephoneNumber
        txt.textAlignment = .center
        return txt
    }()
    
    override func setupViews() {
        super.setupViews()
        refreshView()
        addSubview(txt_input)
        addSubview(btn_minus)
        addSubview(btn_plus)
        
        addConstraint(NSLayoutConstraint(item: btn_minus, attribute: .width, relatedBy: .equal, toItem: btn_minus, attribute: .height, multiplier: 1, constant: 0))
        btn_minus.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        btn_minus.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        btn_minus.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addConstraint(NSLayoutConstraint(item: btn_plus, attribute: .width, relatedBy: .equal, toItem: btn_plus, attribute: .height, multiplier: 1, constant: 0))
        btn_plus.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        btn_plus.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        btn_plus.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: txt_input)
        btn_minus.trailingAnchor.constraint(equalTo: txt_input.leadingAnchor).isActive = true
        btn_plus.leadingAnchor.constraint(equalTo: txt_input.trailingAnchor).isActive = true
        
        btn_plus.addTarget(self, action: #selector(incValue), for: .touchUpInside)
        btn_minus.addTarget(self, action: #selector(decValue), for: .touchUpInside)
    }
    
    func refreshView() {
        btn_plus.setTitleColor(controlFg, for: .normal)
        btn_plus.backgroundColor = controlBg
        btn_plus.titleLabel?.font = btn_plus.titleLabel?.font.withSize(controlFontSize)
        btn_minus.setTitleColor(controlFg, for: .normal)
        btn_minus.backgroundColor = controlBg
        btn_minus.titleLabel?.font = btn_minus.titleLabel?.font.withSize(controlFontSize)
        self.borderColor = controlBg
        txt_input.textColor = color
        txt_input.tintColor = color
        txt_input.text = String(value)
    }
    
    @objc func incValue() {
        value = value < max ? value + 1 : max
    }
    
    @objc func decValue() {
        value = value > min ? value - 1 : min
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let height = self.bounds.height
        self.layer.cornerRadius = height / 2
        self.layer.masksToBounds = true
    }
}
