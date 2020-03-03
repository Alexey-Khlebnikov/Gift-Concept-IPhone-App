//
//  CollectionTabViewCell.swift
//  GIFT_APP
//
//  Created by Alguz on 12/4/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

class CollectionStoryboardViewCell: BaseCell {
    
    private var _viewController: BaseViewController? {
        didSet {
            if let _viewController = self._viewController {
                loadViewController(_viewController)
            }
        }
    }
    public var sender: Any?
    
    private var isInited = false
    
    
    var viewController: BaseViewController? {
        get {
            return _viewController
        }
        set {
            if !isInited {
                isInited = true
                _viewController = newValue
            }
        }
    }
    var controller: BaseViewController?
    
    
    override func setupViews() {
        super.setupViews()
    }
    
    var storyboardInfo: (storyboard: String, identifier: String)?
    
    func loadViewController(_ viewController: BaseViewController) {
        if self.storyboardInfo == nil {
            return
        }
        guard let vc = Global.instantiateVC(storyboardName: storyboardInfo!.storyboard, identifier: storyboardInfo!.identifier) as? BaseViewController else { return
        }
        controller = vc
        vc.sender = self.sender
        
        viewController.addChild(vc)
        addSubviewWithFullSizeConstraints(view: vc.view)
        vc.didMove(toParent: viewController)
    }
    
}
