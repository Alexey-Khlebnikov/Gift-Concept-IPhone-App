//
//  MyTestDismissSegue.swift
//  GIFT_APP
//
//  Created by Alguz on 12/6/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

class MyTestDismissSegue: UIStoryboardSegue {
    override func perform() {
        // Assign the source and destination views to local variables.
        let secondVCView = self.source.view! as UIView
        let firstVCView = self.destination.view! as UIView
     
        let screenHeight = self.destination.parent!.view.frame.height

        self.source.parent?.view.insertSubview(firstVCView, aboveSubview: secondVCView)
     
        // Animate the transition.
        UIView.animate(withDuration: 2, animations: { () -> Void in
            firstVCView.frame = firstVCView.frame.offsetBy(dx: 0.0, dy: screenHeight)
            secondVCView.frame = secondVCView.frame.offsetBy(dx: 0.0, dy: screenHeight)
     
            }) { (Finished) -> Void in
     
                self.source.dismiss(animated: false, completion: nil)
        }
    }
}
