//
//  SegueClasses.swift
//  GIFT_APP
//
//  Created by Alguz on 11/21/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//


import UIKit
import SwiftMessages

class ViewControllersViewController: UIViewController {
    @objc @IBAction private func dismissPresented(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}

class SwiftMessagesTopSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .topMessage)
    }
}

class SwiftMessagesTopCardSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .topCard)
    }
}

class SwiftMessagesTopTabSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .topTab)
    }
}

class SwiftMessagesBottomSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomMessage)
    }
}

class SwiftMessagesBottomCardSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomCard)
    }
}

class SwiftMessagesBottomTabSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomTab)
    }
}

class SwiftMessagesCenteredSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .centered)
    }
}


//class FlipLeftSegue: UIStoryboardSegue {
//    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
//        super.init(identifier: identifier, source: source, destination: destination)
//    }
//    override func perform() {
//        super.perform()
//        
//    }
//}
