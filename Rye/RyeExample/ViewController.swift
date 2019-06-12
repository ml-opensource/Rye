//
//  ViewController.swift
//  RyeExample
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit
import Rye

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rye = RyeViewController.init(type: .`default`(configuration: nil))
            rye.show()
        }
        
    }


}

