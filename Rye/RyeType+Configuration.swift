//
//  RyeAlertType.swift
//  Rye
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

public typealias RyeConfiguration = [Rye.Configuration.Key: Any]

public struct Rye {
    
    public enum AlertType {
        case standard(configuration: RyeConfiguration?)
        case custom(UIView)
    }
    
    public enum Configuration {
        public enum Key: String {
            case backgroundColor
            case textColor
            case textFont
            case text
            case cornerRadius
        }
    }
    
}
