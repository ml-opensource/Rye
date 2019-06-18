//
//  RyeViewController.swift
//  Rye
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

public class RyeViewController: UIViewController {
    
    // MARK: - Properties
    
    var window: UIWindow?
    var ryeView: UIView!
    var isShowing: Bool {
        get {
            let key = "RyeViewControllerIsShowing"
            let value = (UserDefaults.standard.value(forKey: key) as? Bool) ?? false
            return value
        }
        set {
            let key = "RyeViewControllerIsShowing"
            UserDefaults.standard.setValue(newValue,
                                           forKey: key)
        }
    }
    
    // all presentation logic is done using parentView
    var parentView: UIView {
        switch alertType! {
        case .snackBar:
            guard let keyWindow = UIApplication.shared.keyWindow else {
                assertionFailure("Can not present snack bar if there is no keyWindow")
                return UIView()
            }
            return keyWindow
        case .toast:
            return view
        }
    }
    var alertType: Rye.AlertType!
    var viewType: Rye.ViewType!
    var timeAlive: TimeInterval?
    var position: Rye.Position!
    var animationDuration: TimeInterval!
    var animationType: Rye.AnimationType!
    
    // MARK: - Rye View Properties
    
    var ryeViewPositionConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
    /**
     Creates RyeViewController
     
     - Parameter alertType: the Rye AlertType
     - Parameter viewType: the Rye ViewType, contains the UIView + Configuration
     - Parameter position: contains the possition where the RyeView should be displayed on screen
     - Parameter timeAlive: Represents the duration for the RyeView to be displayed to the user. If nil is provided, then you will be responsable of removing the RyeView

     */
    public init(alertType: Rye.AlertType? = .toast,
                viewType: Rye.ViewType? = .standard(configuration: nil),
                at position: Rye.Position? = .bottom(inset: 16),
                timeAlive: TimeInterval? = nil) {
        self.alertType = alertType
        self.viewType = viewType
        self.timeAlive = timeAlive
        self.position = position
        
        switch viewType! {
        case .standard(let configuration):
            animationDuration = configuration?[Rye.Configuration.Key.animationDuration] as? TimeInterval ?? 0.3
            animationType = configuration?[Rye.Configuration.Key.animationType] as? Rye.AnimationType ?? .slideInOut
        default:
            animationDuration = 0.3
            animationType = .slideInOut
        }
        
        super.init(nibName: nil, bundle: nil)
        
        // check if an alert is currently showing and update the isShowing value
        switch alertType! {
        case .toast:
            isShowing = UIApplication.shared.windows.contains(where: {$0.windowLevel == .alert})
        case .snackBar:
            isShowing = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    // MARK: - Display helpers
    
    func showRye(for type: Rye.ViewType) {
        func addRyeView(_ ryeView: UIView) {
            self.ryeView = ryeView
            // add RyeView to hierarchy
            parentView.addSubview(ryeView)
            ryeView.translatesAutoresizingMaskIntoConstraints = false
            ryeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
            
            // setup constraint
            switch position! {
            case .bottom:
                ryeViewPositionConstraint = ryeView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            case .top:
                ryeViewPositionConstraint = ryeView.topAnchor.constraint(equalTo: parentView.topAnchor)
            }
            
            ryeViewPositionConstraint.isActive = true
            
            // force RyeView to layout so it calculates it's frames
            ryeView.setNeedsLayout()
            ryeView.layoutIfNeeded()
            
            // update RyeView bottom constraint constat to position it outside of the application's UIWindow
            switch position! {
            case .bottom:
                ryeViewPositionConstraint.constant = ryeView.frame.height
            case .top:
                ryeViewPositionConstraint.constant = -ryeView.frame.height
            }
        }
        
        switch type {
        case .standard(let configuration):
            
            // create default RyeView
            let ryeView = RyeDefaultView(frame: .zero,
                                         configuration: configuration)
            
            addRyeView(ryeView)
            
        case .custom(let ryeView):
            
            addRyeView(ryeView)

        }
        
        // trigger the dismiss based on timeAlive value
        // a timeAlive of nil will never remove the RyeView
        guard let timeAlive = timeAlive else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeAlive + animationDuration) {
            self.dismiss()
        }
    }
}
