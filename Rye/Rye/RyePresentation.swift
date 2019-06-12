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
        
        // create a new UIWindow
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.windowLevel = .alert
        window.rootViewController = self
        window.backgroundColor = .clear
        window.makeKeyAndVisible()
        
        self.window = window
        
        // create RyeView
        showRye(for: alertType)
        
        // force layout of the view to position the RyeView at the desired location
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        // animate the RyeView on screen
        animateRyeIn(completion: {
            // update Rye state
            RyeViewController.isShowing = true
            
            // trigger status bar update
            self.setNeedsStatusBarAppearanceUpdate()
        })
            
    }
    
    func dismiss(completion: @escaping () -> Void) {
        
        guard window != nil,
            RyeViewController.isShowing else { return }
        
        // animate the RyeView off screen
        animateRyeOut(completion: {
            // remove the UIWindow
            self.window?.isHidden = true
            self.window?.removeFromSuperview()
            self.window = nil
            
            // update Rye state
            RyeViewController.isShowing = false
            
            // trigger status bar update
            self.setNeedsStatusBarAppearanceUpdate()
            
            // call completion
            completion()
        })
        
    }
    
    func animateRyeIn(completion: @escaping () -> Void) {
        
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
        ryeViewBottomConstraint.constant = -safeArea - 16
        
        // animate
        UIView.animate(withDuration: presentationAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
        
    }
    
    func animateRyeOut(completion: @escaping () -> Void) {
        
        // update RyeView bottom constraint to position it off screen
        ryeViewBottomConstraint.constant = view.bounds.height
        
        // animate
        UIView.animate(withDuration: presentationAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
        
    }
}
