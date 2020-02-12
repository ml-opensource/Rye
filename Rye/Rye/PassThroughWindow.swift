//
//  PassThroughWindow.swift
//  Rye
//
//  Created by Andrew Lloyd on 12/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import Foundation

class PassTroughWindow: UIWindow {
    public var passTroughTag: Int?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        let hitView = super.hitTest(point, with: event)

        if let passTroughTag = passTroughTag {
            if passTroughTag == hitView?.tag {
                return nil
            }
        }
        return hitView
    }
}
