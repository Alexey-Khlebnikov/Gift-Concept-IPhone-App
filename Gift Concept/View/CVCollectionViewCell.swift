
//class CVCollectionViewCell: BaseCell {
//
//    var viewController: HomeController!
//    var indentifier: String!
//    var containterInfo: (viewController: HomeController, indentifier: String)! {
//        didSet {
//            viewController = containterInfo.viewController
//            indentifier = containterInfo.indentifier
//            setupViewController()
//        }
//    }
//
//    override func setupViews() {
//        super.setupViews()
//    }
//
//    func setupViewController() {
//        if let CV = viewController.storyboard?.instantiateViewController(withIdentifier: indentifier) {
//            CV.willMove(toParent: viewController)
//            viewController.addChild(CV)
//            self.addSubview(CV.view)
////            viewController.view.frame = bounds
////            CV.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            CV.didMove(toParent: viewController)
//            CV.viewDidLoad()
//        }
//    }
//
//}
