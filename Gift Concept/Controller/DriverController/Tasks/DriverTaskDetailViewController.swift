//
//  DriverTaskDetailViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 2/25/20.
//  Copyright © 2020 Leo Suzin. All rights reserved.
//

import UIKit
import GoogleMaps

class DriverTaskDetailViewController: BaseViewController {
    var deliveryData: DeliveryData!

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var btn_bidNow: BaseButton!
    @IBOutlet weak var btn_accept: BaseButton!
    @IBOutlet weak var btn_revoke: BaseButton!
    @IBOutlet weak var lbl_state: UILabel!
    
    var realMapView: GMSMapView!
    
//    private let locationManager = CLLocationManager()
    
    lazy var sellerMarker: GMSMarker = {
        let icon = UIImage(systemName: "gift.fill")?.withRenderingMode(.alwaysTemplate)
        let marker = self.getShadowMarker(image: icon, title: "Seller", snippet: "")
        marker.iconView?.tintColor = UIColor(rgb: 0xE91E63)
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        return marker
    }()
    
    lazy var userMarker: GMSMarker = {
        let icon = UIImage(systemName: "suit.heart.fill")?.withRenderingMode(.alwaysTemplate)
        let marker = self.getShadowMarker(image: icon, title: "User", snippet: "")
        marker.iconView?.tintColor = .systemBlue
        marker.position = CLLocationCoordinate2D(latitude: -32.86, longitude: 150.20)
        return marker
    }()
    
    lazy var deliverierMarker: GMSMarker = {
        let icon = UIImage(systemName: "car.fill")?.withRenderingMode(.alwaysTemplate)
        let marker = self.getShadowMarker(image: icon, title: "Deliverier", snippet: "")
        marker.iconView?.tintColor = UIColor.systemPurple
        marker.position = CLLocationCoordinate2D(latitude: -32.06, longitude: 152.20)
        return marker
    }()
    

    func getShadowMarker(image: UIImage?, title: String = "", snippet: String = "") -> GMSMarker {
      let marker = GMSMarker()
        marker.title = title
        marker.snippet = snippet
            
      let image = UIImageView(image: image)
      marker.iconView = image
      marker.iconView?.contentMode = .center
      marker.iconView?.bounds.size.width *= 2
      marker.iconView?.bounds.size.height *= 2
      marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)

      marker.iconView?.layer.shadowColor = UIColor.black.cgColor
      marker.iconView?.layer.shadowOffset = CGSize.zero
      marker.iconView?.layer.shadowRadius = 1.0
      marker.iconView?.layer.shadowOpacity = 0.5
            
      let size = image.bounds.size
      let rect = CGRect(x: size.width/2 - size.width/8, y: size.height*0.75 - 2, width: size.width/4, height: 4)
      marker.iconView?.layer.shadowPath = UIBezierPath(ovalIn: rect).cgPath

      marker.appearAnimation = .pop
      marker.position = kCLLocationCoordinate2DInvalid

      return marker
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -32.86, longitude: 151.20, zoom: 7.5)
        let mapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        self.mapView.addSubview(mapView)
        realMapView = mapView

        sellerMarker.map = mapView
        userMarker.map = mapView
        deliverierMarker.map = mapView
        
        let bounds = GMSCoordinateBounds()
        bounds.includingCoordinate(sellerMarker.position)
        bounds.includingCoordinate(userMarker.position)
        bounds.includingCoordinate(deliverierMarker.position)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 0)
        realMapView.setMinZoom(1, maxZoom: 15)
        realMapView.animate(with: update)
        realMapView.setMinZoom(1, maxZoom: 20)
    }
    
    func setupControlBtns() {
        if let deliveryId = self.deliveryData.deliveryId { // accepted any driver
            if deliveryId == User.Me.id { // accepted me
                lbl_state.isHidden = false
                lbl_state.text = "Accepted"
            } else {
                lbl_state.isHidden = true
            }
            btn_bidNow.isHidden = true
            btn_accept.isHidden = true
            btn_revoke.isHidden = true
        } else if self.deliveryData.awardedDeliverierIds.contains(User.Me.id) {
            lbl_state.isHidden = true
            btn_bidNow.isHidden = true
            btn_accept.isHidden = false
            btn_revoke.isHidden = false
        } else if self.deliveryData.deliverierIds.contains(User.Me.id) {
            btn_bidNow.isHidden = true
            btn_accept.isHidden = true
            btn_revoke.isHidden = true
            lbl_state.isHidden = false
            lbl_state.text = "You bidded."
        } else {
            btn_bidNow.isHidden = false
            btn_accept.isHidden = true
            btn_revoke.isHidden = true
            lbl_state.isHidden = true
        }
    }
    
    override func setupSocket() {
        super.setupSocket()
        SocketIOApi.shared.socket.on("bidDelivery") { (arguments, arc) in
            guard let data = arguments[0] as? [String: String] else {
                return
            }
            self.deliveryData.deliverierIds.append(data["deliveryId"]!)
            self.setupControlBtns()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControlBtns()
        setupMap()
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func action_bidNow(_ sender: Any) {
        deliveryData.bidNow { (response) in
            print(response)
        }
    }
    
    @IBAction func action_accept(_ sender: Any) {
        deliveryData.accept { (response) in
            
        }
    }
    
    @IBAction func action_revoke(_ sender: Any) {
    }
    
}

//
//extension DriverTaskDetailViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
//    // 2
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//    // 3
//        guard status == .authorizedWhenInUse else {
//            return
//        }
//        // 4
//        locationManager.startUpdatingLocation()
//
//        //5
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
//    }
//
//    // 6
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//
//        // 7
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//
//        getPlaceAddressFrom(location: location.coordinate) { (address) in
//        }
//        // 8
//        locationManager.stopUpdatingLocation()
//
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        getPlaceAddressFrom(location: coordinate) { (address) in
//        }
//    }
//
//    func getPlaceAddressFrom(location: CLLocationCoordinate2D, completion: @escaping (_ address: String) -> Void) {
//        let geocoder = GMSGeocoder()
//        geocoder.reverseGeocodeCoordinate(location) { response, error in
//            if error != nil {
//                print("reverse geodcode fail: \(error!.localizedDescription)")
//            } else {
//                guard let places = response?.results(),
//                let place = places.first,
//                    let lines = place.lines else {
//                        completion("")
//                        return
//                }
//                completion(lines.joined(separator: ","))
//            }
//        }
//    }
//
//    func showResults(string:String){
//        var input = GInput()
//        input.keyword = string
//        GoogleApi.shared.callApi(input: input) { (response) in
//            if response.isValidFor(.autocomplete) {
//            } else { print(response.error ?? "ERROR") }
//        }
//    }
//    func hideResults(){
//    }
//
//    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if super.textFieldShouldReturn(textField) {
//            return true
//        }
//        return false
//    }
////    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
////        constraintSearchIconWidth.constant = 0.0 ; return true
////    }
////    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
////        constraintSearchIconWidth.constant = 38.0 ; return true
////    }
////
//}
