//
//  RyeDefaultView.swift
//  Rye
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

class RyeDefaultView: UIView {
    
    private(set) var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(configuration: RyeConfiguration?) {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        layer.cornerRadius = (configuration?[.cornerRadius] as? CGFloat) ?? 8
        backgroundColor = (configuration?[.backgroundColor] as? UIColor) ?? UIColor.black.withAlphaComponent(0.4)
        
        makeMessageLabel(
            with: (configuration?[.text] as? String) ?? "Add a message",
            font: (configuration?[.textFont] as? UIFont) ?? UIFont.systemFont(ofSize: 14, weight: .semibold),
            textColor: (configuration?[.textColor] as? UIColor) ?? .white,
            insets: (configuration?[.insets] as? UIEdgeInsets) ?? .zero
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Make Subview
    
    private func makeMessageLabel(with text: String, font: UIFont, textColor: UIColor, insets: UIEdgeInsets) {
        let label = InsetLabel()
        label.contentInsets = insets
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = text
        label.font = font
        label.textColor = textColor
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        self.label = label
    }
}

private class InsetLabel: UILabel {
    
    var contentInsets = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }
    
    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
}
