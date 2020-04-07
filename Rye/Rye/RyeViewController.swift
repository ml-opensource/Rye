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
        guard let keyWindow = UIApplication.shared.keyWindow else {
            assertionFailure("Can not present snack bar if there is no keyWindow")
            return UIView()
        }
        return keyWindow
    }

    var dismissMode: Rye.DismissMode
    var viewType: Rye.ViewType
    var position: Rye.Position
    var animationDuration: TimeInterval!
    var animationType: Rye.AnimationType!
    var dismissCompletion: (() -> Void)? = nil
    private var dismissWorkItem: DispatchWorkItem?
    
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
    public init(dismissMode: Rye.DismissMode = .automatic(interval: Rye.defaultDismissInterval),
                viewType: Rye.ViewType = .standard(configuration: nil),
                at position: Rye.Position = .bottom(inset: 16)) {
        self.dismissMode = dismissMode
        self.viewType = viewType
        self.position = position
        
        switch viewType {
        case .standard(let configuration):
            animationDuration = configuration?[Rye.Configuration.Key.animationDuration] as? TimeInterval ?? 0.3
            animationType = configuration?[Rye.Configuration.Key.animationType] as? Rye.AnimationType ?? .slideInOut
        case .custom(_, let animationType):
            animationDuration = 0.3
            self.animationType = animationType
        }
        
        super.init(nibName: nil, bundle: nil)
        
        // check if an alert is currently showing and update the isShowing value
        isShowing = UIApplication.shared.windows.contains(where: {$0.windowLevel == .alert})
    }
    
    /**
     Creates RyeViewController
     
     - Parameter alertType: the Rye AlertType
     - Parameter viewType: the Rye ViewType, contains the UIView + Configuration
     - Parameter position: contains the possition where the RyeView should be displayed on screen
     - Parameter timeAlive: Represents the duration for the RyeView to be displayed to the user. If nil is provided, then you will be responsable of removing the RyeView
     */
    @available(*, deprecated, message: "Please see the README section \"Updating from v1.x.x to v2.0.0\" for notes on how to update")
    public convenience init(alertType: Rye.AlertType = .toast,
                viewType: Rye.ViewType = .standard(configuration: nil),
                at position: Rye.Position = .bottom(inset: 16),
                timeAlive: TimeInterval? = nil) {
        var dismissMode: Rye.DismissMode
        if let timeAlive = timeAlive {
            dismissMode = .automatic(interval: timeAlive)
        } else {
            dismissMode = .nonDismissable
        }
        self.init(dismissMode: dismissMode,
                  viewType: viewType,
                  at: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    @objc func cancelWorkItemAndDismissRye(_ sender: Any) {
        dismissWorkItem?.cancel()
        dismiss()
    }
    
    // MARK: - Display helpers
    
    func showRye(for type: Rye.ViewType) {
        func addRyeView(_ ryeView: UIView) {
            self.ryeView = ryeView
            
            if shouldAddGestureRecognizer(for: dismissMode) {
                addTapGestureRecognizer()
                addSwipeGestureRecognizer()
            }
        
            // add RyeView to hierarchy
            parentView.addSubview(ryeView)
            ryeView.translatesAutoresizingMaskIntoConstraints = false
            ryeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
            ryeView.widthAnchor.constraint(lessThanOrEqualTo: parentView.widthAnchor, constant: -16).isActive = true
            
            // setup constraint
            switch position {
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
            switch position {
            case .bottom:
                ryeViewPositionConstraint.constant = ryeView.frame.height
            case .top:
                ryeViewPositionConstraint.constant = -ryeView.frame.height
            }
        }
        
        switch type {
        case .standard(let configuration):
            // create default RyeView
            let ryeView = RyeDefaultView(configuration: configuration)
            addRyeView(ryeView)
            
        case .custom(let ryeView, _):
            addRyeView(ryeView)
        }
        
        // trigger the dismiss based on timeAlive value
        switch dismissMode {
        case .automatic(interval: let interval):
            dismissWorkItem = DispatchWorkItem(block: {
                self.dismiss()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + interval + animationDuration,
                                          execute: self.dismissWorkItem!)
        default:
            break
        }
    }
    
    // MARK: - Private Helper methods
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelWorkItemAndDismissRye))
        ryeView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addSwipeGestureRecognizer() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(cancelWorkItemAndDismissRye))
        switch position {
        case .top:
            swipeGestureRecognizer.direction = .up
        case .bottom:
            swipeGestureRecognizer.direction = .down
        }
        ryeView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    private func shouldAddGestureRecognizer(for dismissMode: Rye.DismissMode) -> Bool {
        if case Rye.DismissMode.nonDismissable = dismissMode {
            return false
        } else {
            return true
        }
    }
}
