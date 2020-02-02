//
//  MyTestSegue.swift
//  GIFT_APP
//
//  Created by Alguz on 12/6/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class MyTestSegue: UIStoryboardSegue {
    override func perform() {
        self.destination.modalPresentationStyle = .fullScreen
        // Assign the source and destination views to local variables.
        let firstVCView = self.source.view! as UIView
        let secondVCView = self.destination.view! as UIView

        // Get the screen width and height.
        let screenWidth = self.source.parent!.view.bounds.width
        let screenHeight = self.source.parent!.view.bounds.height

        // Specify the initial position of the destination view.
        secondVCView.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: screenHeight)

        self.source.parent?.view.insertSubview(secondVCView, aboveSubview: firstVCView)

        // Animate the transition.
        UIView.animate(withDuration: 2, animations: { () -> Void in
            firstVCView.frame = firstVCView.frame.offsetBy(dx: 0.0, dy: -screenHeight)
            secondVCView.frame = secondVCView.frame.offsetBy(dx: 0.0, dy: -screenHeight)

            }) { (Finished) -> Void in
//                self.destination.modalPresentationStyle = .fullScreen
//                self.source.present(self.destination as UIViewController,
//                    animated: false,
//                    completion: nil)
        }

    }
}
