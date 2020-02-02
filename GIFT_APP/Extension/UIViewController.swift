//
//  UIViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 10/29/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//
import UIKit

extension UIViewController {
    
    func setupTopWrapper() {
        let topWrapper = BottomReverseRoundedView()
        topWrapper.isUserInteractionEnabled = false
        topWrapper.translatesAutoresizingMaskIntoConstraints = false
        topWrapper.radius = 35
        topWrapper.subView.backgroundColor = .mainColor1
        topWrapper.shadow(left: 0, top: 1.0, feather: 3, color: .black, opacity: 0.5)
        
        var statusBarHeight:CGFloat = 0
        if let statusBar =  UIApplication.statusBarUIView {
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                statusBarHeight = statusBar.frame.height;
            }
        }
        view.addSubview(topWrapper);
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: topWrapper)
        view.addConstraintsWithFormat(format: "V:[v0(\(topWrapper.radius + statusBarHeight))]", views: topWrapper)
        topWrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -statusBarHeight).isActive = true
    }
    
    func setupBackButton() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func bottomBarOffset() -> CGFloat {
        return self.navigationController?.bottomLayoutGuide.length ?? 0
    }
    
    func setBackButton() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_Back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_Back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func keyWindow() -> UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        return keyWindow
    }
}
