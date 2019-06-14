//
//  Nib.swift
//  RyeExample
//
//  Created by Andrei Hogea on 14/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

public protocol NibInitializable {
    static var nibName: String { get }
}

extension NibInitializable where Self: UIView {
    public static func fromNib() -> Self {
        // swiftlint:disable:next force_cast
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as! Self
    }
}

extension UIView: NibInitializable {
    public static var nibName: String { return "\(self)" }
}
