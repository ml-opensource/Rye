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
    var ryeView: UIView?
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
    var parentView: UIView? {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return nil
        }
        return keyWindow
    }
    
    var dismissMode: Rye.DismissMode
    var viewType: Rye.ViewType
    var position: Rye.Position
    var alignment: Rye.Alignment
    var animationDuration: TimeInterval = 0.3
    var ignoreSafeAreas: Bool = false
    var animationType: Rye.AnimationType = .fadeInOut
    var dismissCompletion: (() -> Void)? = nil
    private var dismissWorkItem: DispatchWorkItem?
    
    // MARK: - Rye View Properties
    
    var ryeViewPositionConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    /// Instantiate a new RyeViewController
    /// - Parameters:
    ///   - dismissMode: the Rye AlertType
    ///   - viewType: the Rye ViewType, contains the UIView + Configuration
    ///   - position: contains the possition where the RyeView should be displayed on screen
    ///   - alignment: contains the alignment of where the RyeView should be displayed on screen
    public init(
        dismissMode: Rye.DismissMode = .automatic(interval: Rye.defaultDismissInterval),
        viewType: Rye.ViewType = .standard(configuration: nil),
        at position: Rye.Position = .bottom(inset: 16),
        aligned alignment: Rye.Alignment = .center
    ) {
        self.dismissMode = dismissMode
        self.viewType = viewType
        self.position = position
        self.alignment = alignment
        
        switch viewType {
        case .standard(let configuration):
            animationDuration = configuration?[Rye.Configuration.Key.animationDuration] as? TimeInterval ?? 0.3
            animationType = configuration?[Rye.Configuration.Key.animationType] as? Rye.AnimationType ?? .slideInOut
            ignoreSafeAreas = configuration?[Rye.Configuration.Key.ignoreSafeAreas] as? Bool ?? false
        case .custom(_, let configuration):
            animationDuration = configuration?[Rye.Configuration.Key.animationDuration] as? TimeInterval ?? 0.3
            animationType = configuration?[Rye.Configuration.Key.animationType] as? Rye.AnimationType ?? .slideInOut
            ignoreSafeAreas = configuration?[Rye.Configuration.Key.ignoreSafeAreas] as? Bool ?? false
        }
        
        super.init(nibName: nil, bundle: nil)
        
        // check if an alert is currently showing and update the isShowing value
        isShowing = UIApplication.shared.windows.contains(where: {$0.windowLevel == .alert})
    }
    
    /// Instantiate a new RyeViewController
    /// - Parameters:
    ///   - alertType: the Rye AlertType
    ///   - viewType: the Rye ViewType, contains the UIView + Configuration
    ///   - position: contains the possition where the RyeView should be displayed on screen
    ///   - timeAlive: Represents the duration for the RyeView to be displayed to the user. If nil is provided, then you will be responsable of removing the RyeView
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
            guard let parentView = parentView else {
                NSLog("A parentView could not be found to display the Rye message on. Are you trying to show a Rye message before the view lifecycle is ready to display views?")
                return
            }
            
            self.ryeView = ryeView
            
            if shouldAddGestureRecognizer(for: dismissMode) {
                addTapGestureRecognizer()
                addSwipeGestureRecognizer()
            }
            
            
            // add RyeView to hierarchy
            parentView.addSubview(ryeView)
            ryeView.translatesAutoresizingMaskIntoConstraints = false
            switch alignment {
            case .leading(inset: let inset):
                ryeView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: inset).isActive = true
                
            case .center:
                ryeView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
            
            case .trailing(inset: let inset):
                ryeView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -inset).isActive = true
            }
            
            ryeView.widthAnchor.constraint(lessThanOrEqualTo: parentView.widthAnchor, constant: -16).isActive = true
            
            // setup constraint
            switch position {
            case .bottom:
                ryeViewPositionConstraint = ryeView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            case .top:
                ryeViewPositionConstraint = ryeView.topAnchor.constraint(equalTo: parentView.topAnchor)
            }
            
            ryeViewPositionConstraint?.isActive = true
            
            // force RyeView to layout so it calculates it's frames
            ryeView.setNeedsLayout()
            ryeView.layoutIfNeeded()
            
            // update RyeView bottom constraint constat to position it outside of the application's UIWindow
            switch position {
            case .bottom:
                ryeViewPositionConstraint?.constant = ryeView.frame.height
            case .top:
                ryeViewPositionConstraint?.constant = -ryeView.frame.height
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
            if let dismissWorkItem = self.dismissWorkItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + interval + animationDuration,
                                              execute: dismissWorkItem)
            }
        default:
            break
        }
    }
    
    // MARK: - Private Helper methods
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelWorkItemAndDismissRye))
        ryeView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addSwipeGestureRecognizer() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(cancelWorkItemAndDismissRye))
        switch position {
        case .top:
            swipeGestureRecognizer.direction = .up
        case .bottom:
            swipeGestureRecognizer.direction = .down
        }
        ryeView?.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    private func shouldAddGestureRecognizer(for dismissMode: Rye.DismissMode) -> Bool {
        if case Rye.DismissMode.nonDismissable = dismissMode {
            return false
        } else {
            return true
        }
    }
}
