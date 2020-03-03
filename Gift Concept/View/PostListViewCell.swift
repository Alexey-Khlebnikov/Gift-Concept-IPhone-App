//
//  PostListView.swift
//  GIFT_APP
//
//  Created by Alguz on 10/31/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//
import MaterialComponents

class PostListViewCell: BaseCell {
    var viewController: HomeController! {
        didSet {
            guard isInited else {
                isInited = true
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let childController = mainStoryboard.instantiateViewController(identifier: "PostListViewController")
                
                viewController.addChild(childController)
                
                addSubview(childController.view)
                childController.view.translatesAutoresizingMaskIntoConstraints = false
                
                childController.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                childController.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                childController.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
                childController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

                childController.didMove(toParent: viewController)
                return
            }
        }
    }
    private var isInited = false
    override func setupViews() {
        super.setupViews()
    }
}
