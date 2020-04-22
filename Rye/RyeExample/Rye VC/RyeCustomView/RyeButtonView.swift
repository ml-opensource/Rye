//
//  RyeButtonView.swift
//  RyeExample
//
//  Created by Andrei Hogea on 14/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

protocol RyeButtonViewDelegate: class {
    func didTapButton(in sender: RyeButtonView)
}

class RyeButtonView: UIView {
    
    weak var delegate: RyeButtonViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        
        layer.cornerRadius = 25
        backgroundColor = UIColor.red.withAlphaComponent(0.4)
    }
    
    @IBAction func reconnectAction(_ sender: Any) {
        print("reconnect")
        delegate?.didTapButton(in: self)
    }
}
