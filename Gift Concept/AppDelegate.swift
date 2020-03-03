//
//  AppDelegate.swift
//  Gift Concept
//
//  Created by Alguz on 3/3/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//
//
//  AppDelegate.swift
//  GIFT_APP
//
//  Created by Alguz on 10/28/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(SocketIOApi.shared)
        // Override point for customization after application launch.
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        let attributes = [NSAttributedString.Key.font:  UIFont(name: "Helvetica-Bold", size: 0.1)!, NSAttributedString.Key.foregroundColor: UIColor.clear]

        BarButtonItemAppearance.setTitleTextAttributes(attributes, for: .normal)
        BarButtonItemAppearance.setTitleTextAttributes(attributes, for: .highlighted)
        return true
    }

    func switchToVC(_ viewController: UIViewController) {
        self.window?.rootViewController = viewController
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        User.Me.logout(isExit: true)
    }

}


extension UIApplication {
    
    static var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        }
        let statusBar: UIView? = UIApplication.shared.value(forKey: "statusBar") as? UIView
        return statusBar
    }
    
    static var keyWindow: UIWindow? {
        get {
            return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        }
    }
    
    static var presentedViewController: UIViewController? {
        get {
            var presentViewController = UIApplication.keyWindow?.rootViewController
            while let pVC = presentViewController?.presentedViewController
            {
                presentViewController = pVC
            }
            return presentViewController
        }
    }
}
