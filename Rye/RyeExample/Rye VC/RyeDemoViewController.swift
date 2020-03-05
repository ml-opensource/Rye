//
//  ViewController.swift
//  RyeExample
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit
import Rye

class RyeDemoViewController: UIViewController {
    
    var ryeViewController: RyeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        displayCustomSnackBar()
        displayStandardRyeMessage()
    }
    
    private func x() {
        let ryeConfiguration: RyeConfiguration = [
            Rye.Configuration.Key.text: "Some text",
            Rye.Configuration.Key.backgroundColor: UIColor.systemRed,
            Rye.Configuration.Key.cornerRadius: CGFloat(16),
            Rye.Configuration.Key.textFont: UIFont.systemFont(ofSize: 16),
            Rye.Configuration.Key.animationType: Rye.AnimationType.slideInOut
        ]
        
        let rye = RyeViewController(viewType: .standard(configuration: ryeConfiguration),
                                    at: .top(inset: 106),
                                    timeAlive: 12.5)
        rye.show()
    }

    private func displayDefaultToast() {
        // display Default Rye
        
        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(viewType: .standard(configuration: ryeConfiguration),
                                             at: .bottom(inset: 16),
                                             timeAlive: 20)
            rye.show()
        }
    }
    
    private func displayDefaultToastWithCustomConfiguration() {
        // display Default Rye with custom configuration
        
        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Error message for the user",
                                                  Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.4),
                                                  Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(viewType: .standard(configuration: ryeConfiguration),
                                             at: .bottom(inset: 16),
                                             timeAlive: 2)
            rye.show()
        }
    }
    
    private func displayCustomToast() {
        // display Custom Rye
        
        let customRyeView = RyeView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(viewType: .custom(customRyeView),
                                             at: .bottom(inset: 16),
                                             timeAlive: 2)
            rye.show()
        }
    }
    
    private func displayStandardRyeMessage() {
        let ryeConfiguration: RyeConfiguration = [
            Rye.Configuration.Key.text : "Plain old standard hello from rye",
            Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.7),
            Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController(viewType: .standard(configuration: ryeConfiguration),
                                        at: .top(inset: 0.0),
                                        timeAlive: 5.0)
            rye.show()
        }
    }
    
    private func displayCustomRyeMessage() {
        let customRyeView = RyeButtonView.fromNib()
        customRyeView.delegate = self
//        let customRyeView = RyeImageView.fromNib()
        
        ryeViewController = RyeViewController(viewType: .custom(customRyeView, animationType: .fadeInOut),
                                    at: .bottom(inset: 0.0),
                                    timeAlive: 10.0)
        
        ryeViewController?.show()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        displayCustomRyeMessage()
    }
}

extension RyeDemoViewController: RyeButtonViewDelegate {
    func didTapButton(in sender: RyeButtonView) {
        ryeViewController?.dismiss()
    }
}

