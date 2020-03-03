//
//  NewPostController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/11/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import UIKit
import MaterialComponents
import GoogleMaps
import THCalendarDatePicker
import PhoneNumberKit

class NewPostController: BaseViewController {
    
    private let locationManager = CLLocationManager()


    @IBOutlet weak var v_PinkView: UIView!
    @IBOutlet weak var txt_post_name: BaseTextField!
    @IBOutlet weak var txtv_post_content: UITextView!
    @IBOutlet weak var btn_addFiles: MDCFloatingButton!
    @IBOutlet weak var cnt_attachViewHeight: NSLayoutConstraint!
    @IBOutlet weak var clv_view: UICollectionView!
    @IBOutlet weak var v_contentView: UIView!
    @IBOutlet weak var v_attachContainer: UIView!
    @IBOutlet weak var slv_view: UIScrollView!
    @IBOutlet weak var txt_minPrice: BaseTextField!
    @IBOutlet weak var txt_maxPrice: BaseTextField!
    @IBOutlet weak var txt_dropDown: Select2!
    @IBOutlet weak var btn_next: MDCFloatingButton!
    @IBOutlet weak var btn_post: MDCFloatingButton!
    @IBOutlet weak var btn_cancel: MDCFloatingButton!
    @IBOutlet weak var btn_before: MDCFloatingButton!
    @IBOutlet weak var slv_background: UIScrollView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchAddressTextField: BaseTextField!
    @IBOutlet weak var searchResultView: UITableView!
    @IBOutlet weak var lbl_deliveryAddress: UILabel!
    @IBOutlet weak var txt_deliveryDate: UITextField!
    @IBOutlet weak var txt_deliveryTime: Select2!
    @IBOutlet weak var txt_contactPhoneNumber: PhoneNumberTextField!
    @IBOutlet weak var v_deliveryTitle: UIView!
    @IBOutlet weak var switch_withDelivery: UISwitch!
    
    var rootViewController: UIViewController!
    
    var categoryId: String!
    var autocompleteResults :[GApiResponse.Autocomplete] = []
    var priceUnits: [PriceUnit] = []
    
    var deliveryDate: Date?
    var selectedDate: Date?
    
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = .yellow
        return dp
    }()

    @objc func dateButtonTouched(sender: AnyObject) {
        datePicker.date = Date()
        datePicker.setDateHasItemsCallback({(date:Date!) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        })
        let dic: NSDictionary = [
            KNSemiModalOptionKeys.pushParentBack!: NSNumber(value: false),
             KNSemiModalOptionKeys.animationDuration! : NSNumber(value: 1.0),
             KNSemiModalOptionKeys.shadowOpacity!: NSNumber(value: 0.3)
        ]
        self.presentSemiViewController(datePicker, withOptions: dic as? [AnyHashable : Any])
    }
    
    override func viewDidLoad() {
        rootScrollView = slv_view
        super.viewDidLoad()
        txt_contactPhoneNumber.withPrefix = true
        txt_contactPhoneNumber.withFlag = true
        txt_contactPhoneNumber.withExamplePlaceholder = true
        if #available(iOS 11.0, *) {
            txt_contactPhoneNumber.withDefaultPickerUI = true
        }
        v_deliveryTitle.backgroundColor = .mainColor1
        
        searchAddressTextField.isMandatory = false
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
        view.backgroundColor = .mainColor1
        v_PinkView.backgroundColor = .mainColor1
        updateAttachListView()
        v_contentView.shadow(left: 0, top: 10, feather: 20, color: .black, opacity: 0.1)
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        v_attachContainer.layer.cornerRadius = 5
        v_attachContainer.layer.masksToBounds = true
        v_attachContainer.layer.borderWidth = 1
        v_attachContainer.layer.borderColor = UIColor(rgb: 0xDDDDDD).cgColor
        
        setupDropDown()
        setupDeliveryControls()
        
        print(Date().timeIntervalSince1970)
        
    }
    
    var currentPage: CGFloat = 0 {
        didSet {
            slv_background.setContentOffset(CGPoint(x: slv_background.frame.width * currentPage, y: 0), animated: true)
        }
    }
    
    @IBAction func action_next(_ sender: Any) {
        if currentPage == 0 {
            var isEnable = true
            isEnable = txt_post_name.validate() && isEnable
            isEnable = txt_dropDown.validate() && isEnable
            isEnable = txt_minPrice.validate() && isEnable
            isEnable = txt_maxPrice.validate() && isEnable
            guard isEnable else {
                return
            }
        }
        currentPage += 1
        
        if currentPage == 2 {
            btn_next.isHidden = true
            btn_post.isHidden = false
        }
        if currentPage == 1 {
            btn_cancel.isHidden = true
            btn_before.isHidden = false
        }
        
        
    }
    
    @IBAction func action_before(_ sender: Any) {
        currentPage -= 1

        if currentPage == 1 {
            btn_post.isHidden = true
            btn_next.isHidden = false
        }
        if currentPage == 0 {
            btn_cancel.isHidden = false
            btn_before.isHidden = true
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let should = super.gestureRecognizer(gestureRecognizer, shouldReceive: touch)
        if !should {
            return false
        }
        if let cell = touch.view?.superview as? UITableViewCell {
            if cell.reuseIdentifier == "DropDownCell" {
                return false
            }
            if cell.reuseIdentifier == "searchResultCell" {
                return false
            }
        }
        if let dropDown = txt_dropDown {
            if dropDown.isSelected {
                txt_dropDown.hideList()
            }
        }
        if let deliveryTime = txt_deliveryTime {
            if deliveryTime.isSelected {
                txt_deliveryTime.hideList()
            }
        }
        return true
    }
    
    func setupDropDown() {
        PriceUnit.all { (units) in
            self.priceUnits = units
            // The list of array to display. Can be changed dynamically
            self.txt_dropDown.optionArray = units.map({return "\($0.symbol) (\($0.name))"})
            //Its Id Values and its optional
//            self.txt_dropDown.optionIds = [23,54,22]

            // Image Array its optional
//            self.txt_dropDown.optionImageArray = [UIImage(named: "icon_Home"),UIImage(named: "icon_Home"),UIImage(named: "icon_Home")]
            
            // The the Closure returns Selected Index and String
            self.txt_dropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index) \n id: \(id)")
            }
           
        }
    }
    
    var deliveryTimeSchedules: [DeliveryTimeSchedule] = []
    func setupDeliveryControls() {
        DeliveryTimeSchedule.all { (list) in
            self.deliveryTimeSchedules = list
            self.txt_deliveryTime.optionArray = list.map({return "\($0.startTime):00 ~ \($0.endTime):00"})
            self.txt_deliveryTime.isSearchEnable = false
        }
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector(dateButtonTouched))
        self.txt_deliveryDate.addGestureRecognizer(gesture)
        
        selectedDate = Date()
    }
    
    
    func updateAttachListView() {
        cnt_attachViewHeight.constant = CGFloat(imageList.count * (80 + 8) + 2)
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.clv_view.reloadData()
            self.updateAttachListView()
        }
    }
    
    var imageList: [ImageInfo] = []
    var imagePicker: ImagePicker!
    
    @IBAction func Action_Post(_ sender: Any) {
        let post = Post()
        post.categoryId = categoryId
        post.name = txt_post_name.text!
        post.content = txtv_post_content.text
        post.attaches = imageList
        post.priceUnit = priceUnits[txt_dropDown.selectedIndex ?? 0]
        post.minPrice = Float(txt_minPrice.text ?? "0")!
        post.maxPrice = Float(txt_maxPrice.text ?? "0")!
        post.deliveryAddress = lbl_deliveryAddress.text ?? ""
        post.deliveryMethod = switch_withDelivery.isOn ? 1 : 0
        post.deliveryDate = deliveryDate!.timeIntervalSince1970
        post.deliveryTimeScheduleId = deliveryTimeSchedules[txt_deliveryTime.selectedIndex ?? 0].id
        post.contactPhoneNumber = txt_contactPhoneNumber.text ?? ""
        
        post.createPost(onSuccess: { (postData) in
            let detailViewController = Global.instantiateVC(storyboardName: "Main", identifier: "PostDetailViewController") as! PostDetailViewController
            detailViewController.post = postData
            self.dismiss(animated: true, completion: nil)
            self.rootViewController.navigationController?.pushViewController(detailViewController, animated: false)
        }) { (error) in
            print(error ?? "createPost error")
        }
    }
    
    @IBAction func Action_Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension NewPostController: THDatePickerDelegate {
    func datePickerDonePressed(_ datePicker: THDatePickerViewController!) {
        self.dismissSemiModalView()
        deliveryDate = self.selectedDate
        txt_deliveryDate.text = self.selectedDate?.localDateString
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        self.dismissSemiModalView()
    }
    
    func datePicker(_ datePicker: THDatePickerViewController!, selectedDate: Date!) {
        self.selectedDate = selectedDate
    }
}

extension NewPostController: ImagePickerDelegate {
    func didSelect(image: UIImage?, url: URL?) {
        if image == nil || url == nil {
            return
        }
        let imageInfo = ImageInfo()
        imageInfo.image = image
        imageInfo.dimension = image!.dimension
        imageInfo.fullName = url!.lastPathComponent
        imageInfo.mimeType = url!.mimeType()
        imageList.append(imageInfo)
        reload()
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        if imageList.count >= 4 {
            print("You can upload up to 4 images")
            return
        }
        imagePicker.present(from: sender)
    }
    
}


extension NewPostController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostAttachViewCell", for: indexPath) as! PostAttachViewCell
        cell.imageInfo = imageList[indexPath.item]
        cell.viewController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

// MARK: - CLLocationManagerDelegate
//1
extension NewPostController: CLLocationManagerDelegate, GMSMapViewDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
          
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
  
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
          
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        getPlaceAddressFrom(location: location.coordinate) { (address) in
            self.lbl_deliveryAddress.text = address
        }
        // 8
        locationManager.stopUpdatingLocation()
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        getPlaceAddressFrom(location: coordinate) { (address) in
            self.lbl_deliveryAddress.text = address
        }
    }
    
    func getPlaceAddressFrom(location: CLLocationCoordinate2D, completion: @escaping (_ address: String) -> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(location) { response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                guard let places = response?.results(),
                let place = places.first,
                    let lines = place.lines else {
                        completion("")
                        return
                }
                completion(lines.joined(separator: ","))
            }
        }
    }
    
    func showResults(string:String){
        var input = GInput()
        input.keyword = string
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    if self.autocompleteResults.count > 0 {
                        self.searchResultView.isHidden = false
                    } else {
                        self.searchResultView.isHidden = true
                    }
                    self.searchResultView.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
    func hideResults(){
        autocompleteResults.removeAll()
        searchResultView.reloadData()
        searchResultView.isHidden = true
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if super.textFieldShouldReturn(textField) {
            return true
        }
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchAddressTextField {
            let text = textField.text! as NSString
            let fullText = text.replacingCharacters(in: range, with: string)
            if fullText.count > 2 {
                showResults(string:fullText)
            }else{
                hideResults()
            }
        }
        return true
    }
//    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        constraintSearchIconWidth.constant = 0.0 ; return true
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        constraintSearchIconWidth.constant = 38.0 ; return true
//    }
//
}

extension NewPostController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        let label = cell?.viewWithTag(1) as! UILabel
        label.text = autocompleteResults[indexPath.row].formattedAddress
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchAddressTextField.text = autocompleteResults[indexPath.row].formattedAddress
        searchAddressTextField.resignFirstResponder()
        var input = GInput()
        input.keyword = autocompleteResults[indexPath.row].placeId
        
        self.hideResults()
        
        GoogleApi.shared.callApi(.placeInformation,input: input) { (response) in
            if let place =  response.data as? GApiResponse.PlaceInfo, response.isValidFor(.placeInformation) {
                DispatchQueue.main.async {
                    
                    if let lat = place.latitude, let lng = place.longitude{
                        let center  = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        self.mapView.camera = GMSCameraPosition(target: center, zoom: 15, bearing: 0, viewingAngle: 0)
//                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//                        self.mapView.setRegion(region, animated: true)
                    }
                    self.searchResultView.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
}

class PostAttachViewCell: UICollectionViewCell {
    
    var viewController: NewPostController?
    var imageInfo: ImageInfo? {
        didSet {
            imageView.image = self.imageInfo?.image
            tf_iamge_name.text = self.imageInfo?.fileName
            lbl_dimension.text = self.imageInfo?.dimension
            lbl_filesize.text = self.imageInfo?.fileSizeString
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tf_iamge_name: UITextField!
    @IBOutlet weak var lbl_dimension: UILabel!
    @IBOutlet weak var lbl_filesize: UILabel!
    @IBAction func removeFile(_ sender: Any) {
        var flag = false
        viewController?.imageList.removeAll(where: { (info) -> Bool in
            if info == self.imageInfo {
                flag = true
                return true
            }
            return false
        })
        if flag {
            self.viewController?.reload()
        }
        
    }
    @IBAction func chnageName(_ sender: UITextField) {
        self.imageInfo?.fileName = sender.text ?? ""
    }
    
}
