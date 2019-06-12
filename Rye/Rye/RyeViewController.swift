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
    static var isShowing: Bool = false
    
    var alertType: Rye.AlertType!
    
    // MARK: - Rye View Properties
    
    var ryeViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
    public init(type: Rye.AlertType) {
        self.alertType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    // MARK: - Display helpers
    
    func showRye(for type: Rye.AlertType) {
        guard !RyeViewController.isShowing else {
            return
        }
        
        switch type {
        case .default(let configuration):
            
            // create default RyeView
            let ryeView = RyeDefaultView(frame: .zero,
                                         configuration: configuration)
            
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
            
        case .custom(let view):
            break
        }
        
//        animateRyeIn()
    }
}
