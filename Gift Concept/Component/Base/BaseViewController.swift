//
//  BaseViewController.swift
//  GIFT_APP
//
//  Created by Alguz on 11/30/19.
//  Copyright © 2019 Leo Suzin. All rights reserved.
//

import Foundation
import UIKit
import _SwiftUIKitOverlayShims

public protocol ViewDidLoadDelegate: NSObjectProtocol {
    func viewDidLoad(_ viewController: BaseViewController)
}

public class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var superViewController: UIViewController?
    
    override public var prefersStatusBarHidden: Bool {
        return false
    }
    
    var sender: Any?
    
    var viewDidLoadDelegate: ViewDidLoadDelegate?
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var globalGestureEnabled: Bool = true

    var rootScrollView: UIScrollView! {
        didSet {
            setupKeyboard()
        }
    }
    var focusedControl: UIView!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadDelegate?.viewDidLoad(self)
        setupSocket()
    }
    
    
    func setupSocket() {
        
    }
    
    
    
    func setupKeyboard() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        if globalGestureEnabled {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
            tapGesture.delegate = self
            self.view.addGestureRecognizer(tapGesture)
        }

    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? BaseViewController
        vc?.sender = sender
    }

    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if !self.isViewLoaded || self.view == nil || self.view!.window == nil {
            return
        }
        guard let info = notification.userInfo else { return }
        guard let keyboardFrame: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        

        let keyboardFrameInWindow = keyboardFrame.cgRectValue
        let keyboardFrameInView: CGRect = self.view.convert(keyboardFrameInWindow, from: nil)
        let scrollViewKeyboardIntersection = rootScrollView.frame.intersection(keyboardFrameInView)
        
        let newContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: scrollViewKeyboardIntersection.size.height, right: 0)
        
        if let durationNumber = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardCurveNumber = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            let duration = durationNumber.doubleValue
            let keyboardCurve = keyboardCurveNumber.uintValue
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: keyboardCurve), animations: {
                self.rootScrollView.contentInset = newContentInsets
                self.rootScrollView.scrollIndicatorInsets = newContentInsets
                
                if self.focusedControl != nil {
                    // if the control is a deep in the hierarchy below the scroll view, this will calculate the frame as if it were a direct subview
                    var controlFrameInScrollView = self.rootScrollView.convert(self.focusedControl.bounds, from: self.focusedControl)
                     // replace 10 with any nice visual offset between control and keyboard or control and top of the scroll view.
                    controlFrameInScrollView = controlFrameInScrollView.insetBy(dx: 0, dy: -10)
                    
                    let controlVisualOffsetToTopOfScrollview = controlFrameInScrollView.origin.y - self.rootScrollView.contentOffset.y
                    let controlVisualBottom =  controlVisualOffsetToTopOfScrollview + controlFrameInScrollView.size.height
                    
                    // this is the visible part of the scroll view that is not hidden by the keyboard
                    let scrollViewVisibleHeight =  self.rootScrollView.frame.size.height - scrollViewKeyboardIntersection.size.height
                    
                    if controlVisualBottom > scrollViewVisibleHeight {// check if the keyboard will hide the control in question
                        // scroll up until the control is in place
                        var  newContentOffset = self.rootScrollView.contentOffset;
                        newContentOffset.y += (controlVisualBottom - scrollViewVisibleHeight)
                        
                        // make sure we don't set an impossible offset caused by the "nice visual offset"
                        // if a control is at the bottom of the scroll view, it will end up just above the                         keyboard to eliminate scrolling inconsistencies
                        newContentOffset.y = min(newContentOffset.y, self.rootScrollView.contentSize.height - scrollViewVisibleHeight)
                        self.rootScrollView.setContentOffset(newContentOffset, animated: false) // animated:NO because we have created our own animation context around this code
                    } else if controlFrameInScrollView.origin.y < self.rootScrollView.contentOffset.y { // if the control is not fully visible, make it so (useful if the user taps on a partially visible input field
                        var newContentOffset = self.rootScrollView.contentOffset
                        newContentOffset.y = controlFrameInScrollView.origin.y
                        self.rootScrollView.setContentOffset(newContentOffset, animated: false) // animated:NO because we have created our own animation context around this code
                    }
                }
            }, completion: nil)
        }
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc private func keyboardWillHide(_ notification: Notification) {
        // if we have no view or are not visible in any window, we don't care
        if !self.isViewLoaded || self.view == nil || self.view!.window == nil {
            return
        }
        guard let info = notification.userInfo else { return }
        if let durationNumber = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardCurveNumber = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            let duration = durationNumber.doubleValue
            let keyboardCurve = keyboardCurveNumber.uintValue
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: keyboardCurve), animations: {
                self.rootScrollView.contentInset = UIEdgeInsets.zero
                self.rootScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
            }, completion: nil)
        }
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if let textView = focusedControl as? UITextView {
            let shouldReturn = self.textViewShouldReturn(textView)
            textView.endEditing(shouldReturn)
        } else if let textField = focusedControl as? UITextField {
            let shouldReturn = self.textFieldShouldReturn(textField)
            textField.endEditing(shouldReturn)
        }
    }
    
}


extension BaseViewController: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        focusedControl = textField
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension BaseViewController: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        focusedControl = textView
        return true
    }
    
    public func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    
}
