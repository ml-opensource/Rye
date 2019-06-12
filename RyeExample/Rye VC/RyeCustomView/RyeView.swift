//
//  RyeView.swift
//  RyeExample
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

class RyeView: UIView {
    
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        layer.cornerRadius = 25
        backgroundColor = UIColor.red.withAlphaComponent(0.4)
        
        makeMessageLabel(with: "An error occured",
                         font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                         textColor: .white)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Make Subview
    
    private func makeMessageLabel(with text: String, font: UIFont, textColor: UIColor) {
        label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = text
        label.font = font
        label.textColor = textColor
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
}
