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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayCustomToast()
    
    }

    private func displayDefaultToast() {
        // display Default Rye
        
        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(alertType: .toast,
                                             viewType: .standard(configuration: ryeConfiguration),
                                             at: .bottom(inset: 16),
                                             timeAlive: 2)
            rye.show()
        }
    }
    
    private func displayDefaultToastWithCustomConfiguration() {
        // display Default Rye with custom configuration
        
        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Error message for the user",
                                                  Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.4),
                                                  Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(alertType: .toast,
                                             viewType: .standard(configuration: ryeConfiguration),
                                             at: .bottom(inset: 16),
                                             timeAlive: 2)
            rye.show()
        }
    }
    
    private func displayCustomToast() {
        // display Custom Rye
        
        let customRyeView = RyeView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(alertType: .toast,
                                             viewType: .custom(customRyeView),
                                             at: .bottom(inset: 16),
                                             timeAlive: 2)
            rye.show()
        }
    }
    
    private func displayCustomSnackBar() {
        let customRyeView = RyeImageView.fromNib()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(alertType: .snackBar,
                                             viewType: .custom(customRyeView),
                                             at: .top(inset: 16),
                                             timeAlive: nil)
            rye.show()
        }
        
    }
    
    private func displayCustomSnackBarWithButton() {
        let customRyeView = RyeButtonView.fromNib()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(alertType: .snackBar,
                                             viewType: .custom(customRyeView),
                                             at: .top(inset: 16),
                                             timeAlive: nil)
            rye.show()
        }
        
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        print("tap")
    }
}

