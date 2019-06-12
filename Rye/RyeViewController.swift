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
    internal let presentationAnimationDuration: TimeInterval = 0.3
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
    
    var alertType: Rye.AlertType!
    var timeAlive: TimeInterval?
    
    // MARK: - Rye View Properties
    
    var ryeViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
    /**
     Creates RyeViewController
     
     - Parameter type: the Rye type
     - Parameter timeAlive: Represents the duration for the RyeView to be displayed to the user. If nil is provided, then you will be responsable of removing the RyeView

     */
    public init(type: Rye.AlertType, timeAlive: TimeInterval? = nil) {
        self.alertType = type
        self.timeAlive = timeAlive
        super.init(nibName: nil, bundle: nil)
        
        // check if an alert is currently showing and update the isShowing value
        isShowing = UIApplication.shared.windows.contains(where: {$0.windowLevel == .alert})
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
    
    func showRye(for type: Rye.AlertType) {
        func addRyeView(_ ryeView: UIView) {
            // add RyeView to hierarchy
            view.addSubview(ryeView)
            ryeView.translatesAutoresizingMaskIntoConstraints = false
            ryeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            ryeViewBottomConstraint = ryeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ryeViewBottomConstraint.isActive = true
            
            // force RyeView to layout so it calculates it's frames
            ryeView.setNeedsLayout()
            ryeView.layoutIfNeeded()
            
            // update RyeView bottom constraint constat to position it outside of the application's UIWindow
            ryeViewBottomConstraint.constant = ryeView.frame.height
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
        DispatchQueue.main.asyncAfter(deadline: .now() + timeAlive + presentationAnimationDuration) {
            self.dismiss()
        }
    }
}
