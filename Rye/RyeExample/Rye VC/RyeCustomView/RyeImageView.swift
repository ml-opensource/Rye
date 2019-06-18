//
//  RyeImageView.swift
//  RyeExample
//
//  Created by Andrei Hogea on 14/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

class RyeImageView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        
        layer.cornerRadius = 25
        backgroundColor = UIColor.red.withAlphaComponent(0.4)
    }
    
}
