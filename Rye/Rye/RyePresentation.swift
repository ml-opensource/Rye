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
    func show(withDismissCompletion dismissCompletion: (() -> Void)? = nil) {
        self.dismissCompletion = dismissCompletion
        
        // check if we can show the RyeView
        guard !isShowing else {
            NSLog("A Rye alert is already showing. Multiple Ryes can not be presented at the same time")
            return
        }
        
        guard let parentView = parentView else {
            NSLog("A parentView could not be found to display the Rye message on. Are you trying to show a Rye message before the view lifecycle is ready to display views?")
            return
        }
    
        self.window = createAlertWindow()
        
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
    
    func dismiss() {
        guard isShowing else {
            NSLog("Can not dismiss a Rye that it is not showing")
            return
        }
        // animate the RyeView off screen
        
        animateRyeOut(completion: { [weak self] in
            
            guard let self = self else { return }
            
            self.ryeView.removeFromSuperview()
            
            // remove the UIWindow
            self.window?.isHidden = true
            self.window?.removeFromSuperview()
            self.window = nil
            
            // update Rye state
            self.isShowing = false
                        
            // call completion
            self.dismissCompletion?()
        })
    }
    
    private func createAlertWindow() -> UIWindow? {
        let passThroughTag: Int = 99
        // create a new UIWindow
        var window: PassThroughWindow?
        
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared
                .connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first
            if let windowScene = windowScene as? UIWindowScene {
                window = PassThroughWindow(windowScene: windowScene)
                window?.rootViewController?.view.tag = passThroughTag
                window?.passThroughTag = passThroughTag
                
                window?.windowLevel = .alert
                window?.rootViewController = self
                window?.backgroundColor = .clear
            }
        } else {
            window = PassThroughWindow(frame: UIScreen.main.bounds)
            window?.rootViewController?.view.tag = passThroughTag
            window?.passThroughTag = passThroughTag
            
            window?.windowLevel = .alert
            window?.rootViewController = self
            window?.backgroundColor = .clear
        }
        
        return window
    }
    
    internal func animateRyeIn() {
        
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
        
        var ryeViewPositionConstant: CGFloat {
            let safeArea = ignoreSafeAreas ? 0 : getSafeAreaSpacing()
            
            switch position {
            case .bottom(let inset):
                return -safeArea - inset
            case .top(let inset):
                return safeArea + inset
            }
        }
        
        switch self.animationType {
        case .fadeInOut:
            ryeView.alpha = 0
            ryeViewPositionConstraint?.constant = ryeViewPositionConstant
        case .slideInOut:
            ryeView.alpha = 1
            ryeViewPositionConstraint?.constant = ryeViewPositionConstant
        }
        
        // animate
        UIView.animate(withDuration: animationDuration) {
            switch self.animationType {
            case .fadeInOut:
                self.ryeView.alpha = 1
            case .slideInOut:
                self.parentView?.layoutIfNeeded()
            }
        }
        
    }
    
    internal func animateRyeOut(completion: @escaping () -> Void) {
        
        // update RyeView bottom constraint to position it off screen
        
        func getRyeViewPositionConstant() -> CGFloat {
            switch position {
            case .bottom:
                return ryeView.frame.height
            case .top:
                return -ryeView.frame.height
            }
        }
        
        switch self.animationType {
        case .fadeInOut:
            break
        case .slideInOut:
            ryeViewPositionConstraint?.constant = getRyeViewPositionConstant()
        }
        
        // animate
        UIView.animate(withDuration: animationDuration, animations: {
            switch self.animationType {
            case .fadeInOut:
                self.ryeView.alpha = 0
            case .slideInOut:
                self.parentView?.layoutIfNeeded()
            }
        }, completion: { _ in
            completion()
        })
        
    }
}

