//
//  DriverNotificationViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 2/17/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit

class DriverNotificationViewController: BaseViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cnt_newAlertsHeight: NSLayoutConstraint!
    var init_HeightOfNewAlert: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        init_HeightOfNewAlert = cnt_newAlertsHeight.constant
        cnt_newAlertsHeight.constant = 0
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        DeliveryData.getAlldeliveryRequests { (list) in
            self.notifications = list.map({_ in return Alert()})
        }
    }
    
    var notifications: [Alert] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var newNotifications: [Alert] = [] {
        didSet {
            if newNotifications.count == 0 {
                cnt_newAlertsHeight.constant = 0
            } else {
                cnt_newAlertsHeight.constant = init_HeightOfNewAlert
            }
        }
    }

    @IBAction func action_showNewAlerts(_ sender: Any) {
        notifications = notifications + newNotifications
        newNotifications = []
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DriverNotificationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.notification = Alert()
        cell.maxWidth = collectionView.bounds.width
        return cell
    }
}

class NotificationCell: AutoHeightCollectionViewCell {
    var notification: Alert? {
        didSet {
            lbl_alertType.text = notification?.type
            lbl_alertName.text = notification?.name
            lbl_alertContent.text = notification?.content
        }
    }
    @IBOutlet weak var lbl_alertType: UILabel!
    @IBOutlet weak var lbl_alertName: UILabel!
    @IBOutlet weak var lbl_alertContent: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                backgroundColor = UIColor(rgb: 0xCACACA, alpha: 1)
            } else {
                backgroundColor = .white
            }
        }
    }
}
