//
//  RyePresentation.swift
//  Rye
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

// MARK: - Presentaion

public extension RyeViewController {
    func show() {
        
        switch self.alertType! {
        case .toast:
            // create a new UIWindow
            let window = UIWindow(frame: UIScreen.main.bounds)
            
            window.windowLevel = .alert
            window.rootViewController = self
            window.backgroundColor = .clear
            window.makeKeyAndVisible()
            
            self.window = window
        case .snackBar:
            break
        }
        
        // check if we can show the RyeView
        guard !isShowing else {
            NSLog("An Rye is already showing. Multiple Ryes can not be presented at the same time")
            return
        }
        
        // update Rye state
        isShowing = true
        
        // create RyeView
        showRye(for: viewType)
        
        // force layout of the view to position the RyeView at the desired location
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
        
        // animate the RyeView on screen
        animateRyeIn()
            
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        
        guard window != nil,
            isShowing else {
                NSLog("Can not dismiss Rye")
                return
        }
        
        // animate the RyeView off screen
        animateRyeOut(completion: {
            
            switch self.alertType! {
            case .toast:
                // remove the UIWindow
                self.window?.isHidden = true
                self.window?.removeFromSuperview()
                self.window = nil
            case .snackBar:
                // remove the Rye View
                self.ryeView.isHidden = true
                self.ryeView.removeFromSuperview()
                self.ryeView = nil
            }
            
            // update Rye state
            self.isShowing = false
            
            // call completion
            completion?()
        })
        
    }
    
    func animateRyeIn() {
        
        // calculate safeArea based on UIDevice current orientation to facilitate a good positioning of RyeView
        func getSafeAreaSpacing() -> CGFloat {
            switch UIDevice.current.orientation {
            case .faceUp, .faceDown, .portrait, .unknown:
                return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            case .portraitUpsideDown:
                return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
            case .landscapeLeft:
                return UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0
            case .landscapeRight:
                return UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0
            @unknown default:
                return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            }
        }
        
        func getRyeViewPositionConstant() -> CGFloat {
            let safeArea = getSafeAreaSpacing()

            // update RyeView bottom constraint to position it on screen
            switch position! {
            case .bottom(let inset):
                return -safeArea - inset
            case .top(let inset):
                return safeArea + inset
            }
        }
        
        switch self.animationType! {
        case .fadeInOut:
            ryeView.alpha = 0
            ryeViewPositionConstraint.constant = getRyeViewPositionConstant()
        case .slideInOut:
            ryeView.alpha = 1
            ryeViewPositionConstraint.constant = getRyeViewPositionConstant()
        }
        
        // animate
        UIView.animate(withDuration: animationDuration) {
            switch self.animationType! {
            case .fadeInOut:
                self.ryeView.alpha = 1
            case .slideInOut:
                self.parentView.layoutIfNeeded()
            }
        }
        
    }
    
    func animateRyeOut(completion: @escaping () -> Void) {
        
        // update RyeView bottom constraint to position it off screen
        
        func getRyeViewPositionConstant() -> CGFloat {
            switch position! {
            case .bottom:
                return ryeView.frame.height
            case .top:
                return -ryeView.frame.height
            }
        }
        
        switch self.animationType! {
        case .fadeInOut:
            break
        case .slideInOut:
            ryeViewPositionConstraint.constant = getRyeViewPositionConstant()
        }
        
        // animate
        UIView.animate(withDuration: animationDuration, animations: {
            switch self.animationType! {
            case .fadeInOut:
                self.ryeView.alpha = 0
            case .slideInOut:
                self.parentView.layoutIfNeeded()
            }
        }, completion: { _ in
            completion()
        })
        
    }
}
