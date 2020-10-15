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
    
    /**
        default period of time to show an alert in ´DismissMode.automatic´
     */
    public static var defaultDismissInterval: TimeInterval = 2.5
    
    public enum DismissMode {
        /**
         The message will automatically disappear after `interval` seconds
         */
        case automatic(interval: TimeInterval)
        /**
         The message can be dismissed by tapping or swiping it away
         */
        case gesture
        /**
         The message is not dismissable
         */
        case nonDismissable
    }
    
    @available(*, deprecated, message: "Please see the README section \"Updating from v1.x.x to v2.0.0\" for notes on how to update")
    public enum AlertType {
        /**
         a SnackBar alert. Displayed at applications UIViewController level
         */
        case snackBar
        /**
         a Toast like alert. Displayed at alert level of the key UIWindow.
         */
        case toast
    }
        
    public enum ViewType {
        case standard(configuration: RyeConfiguration?)
        case custom(UIView, configuration: RyeConfiguration?)
    }
    
    public enum Configuration {
        public enum Key: String {
            /**
             RyeView's background color
             */
            case backgroundColor
            /**
             RyeView's text color
             */
            case textColor
            /**
             RyeView's font
             */
            case textFont
            /**
             RyeView's text
             */
            case text
            /**
             RyeView's corner radius
             */
            case cornerRadius
            /**
             RyeView's animation type
             */
            case animationType
            /**
             RyeView's animation duration
             */
            case animationDuration
            /**
            RyeView's insets
            */
            case insets
            /**
            Should the Rye view ignore safeAreaInsets
             */
            case ignoreSafeAreas
        }
    }
    
    public enum Position {
        case top(inset: CGFloat)
        case bottom(inset: CGFloat)
    }
    
    public enum AnimationType {
        case slideInOut
        case fadeInOut
    }
}
