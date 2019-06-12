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
        
        displayCustomRyeView()
        displayDefaultRye()
    
    }

    private func displayDefaultRye() {
        // display Default Rye
        
        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(type: .`default`(configuration: ryeConfiguration))
            rye.show()
        }
    }
    
    private func displayDefaultRyeWithCustomConfiguration() {
        // display Default Rye with custom configuration
        
        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Error message for the user",
                                                  Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.4)]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(type: .`default`(configuration: ryeConfiguration))
            rye.show()
        }
    }
    
    private func displayCustomRyeView() {
        // display Custom Rye
        
        let customRyeView = RyeView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(type: .custom(customRyeView))
            rye.show()
        }
    }
}

