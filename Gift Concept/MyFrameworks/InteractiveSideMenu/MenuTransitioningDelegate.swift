//
//  MenuTransitioningDelegate.swift
//  GIFT_APP
//
//  Created by Alguz on 12/3/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation

/**
 Delegate of menu transitioning actions.
 */
final class MenuTransitioningDelegate: NSObject {

    let interactiveTransition: MenuInteractiveTransition

    public var currentItemOptions = SideMenuItemOptions() {
        didSet {
            interactiveTransition.currentItemOptions = currentItemOptions
        }
    }

    init(interactiveTransition: MenuInteractiveTransition) {
        self.interactiveTransition = interactiveTransition
    }
}

extension MenuTransitioningDelegate: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        interactiveTransition.present = true
        return interactiveTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        interactiveTransition.present = false
        return interactiveTransition
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.interactionInProgress ? interactiveTransition : nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.interactionInProgress ? interactiveTransition : nil
    }
}
