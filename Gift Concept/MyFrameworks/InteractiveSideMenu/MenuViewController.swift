//
//  MenuViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 12/3/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

open class MenuViewController: UIViewController {

    public weak var menuContainerViewController: MenuContainerViewController?
    var navigationMenuTransitionDelegate: MenuTransitioningDelegate? 
    @objc func handleTap(recognizer: UIGestureRecognizer){
        menuContainerViewController?.hideSideMenu()
    }
}
