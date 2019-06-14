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
        let safeArea: CGFloat
        switch UIDevice.current.orientation {
        case .faceUp, .faceDown, .portrait, .unknown:
            safeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        case .portraitUpsideDown:
            safeArea = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        case .landscapeLeft:
            safeArea = UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0
        case .landscapeRight:
            safeArea = UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0
        @unknown default:
            safeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        
        // update RyeView bottom constraint to position it on screen
        switch position {
        case .bottom(let inset)?:
            ryeViewPositionConstraint.constant = -safeArea - inset
        case .top(let inset)?:
            ryeViewPositionConstraint.constant = safeArea + inset
        default: break
        }
        
        // animate
        UIView.animate(withDuration: presentationAnimationDuration) {
            self.parentView.layoutIfNeeded()
        }
        
    }
    
    func animateRyeOut(completion: @escaping () -> Void) {
        
        // update RyeView bottom constraint to position it off screen
        switch position {
        case .bottom?:
            ryeViewPositionConstraint.constant = ryeView.frame.height
        case .top?:
            ryeViewPositionConstraint.constant = -ryeView.frame.height
        default: break
        }
        
        // animate
        UIView.animate(withDuration: presentationAnimationDuration, animations: {
            self.parentView.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
        
    }
}
