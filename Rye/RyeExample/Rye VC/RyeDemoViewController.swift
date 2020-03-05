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
    
    var ryeViewController: RyeViewController?
    var isShowingNonDismissableMessage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        displayCustomSnackBar()
        displayStandardRyeMessage()
    }
    
    private func x() {
        let ryeConfiguration: RyeConfiguration = [
            Rye.Configuration.Key.text: "Some text",
            Rye.Configuration.Key.backgroundColor: UIColor.systemRed,
            Rye.Configuration.Key.cornerRadius: CGFloat(16),
            Rye.Configuration.Key.textFont: UIFont.systemFont(ofSize: 16),
            Rye.Configuration.Key.animationType: Rye.AnimationType.slideInOut
        ]
        
        let rye = RyeViewController(viewType: .standard(configuration: ryeConfiguration),
                                    at: .top(inset: 106))
        rye.show()
    }

//    private func displayDefaultToast() {
//        // display Default Rye
//
//        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Message for the user"]
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let rye = RyeViewController.init(viewType: .standard(configuration: ryeConfiguration),
//                                             at: .bottom(inset: 16),
//                                             timeAlive: 20)
//            rye.show()
//        }
//    }
//
//    private func displayDefaultToastWithCustomConfiguration() {
//        // display Default Rye with custom configuration
//
//        let ryeConfiguration: RyeConfiguration = [Rye.Configuration.Key.text: "Error message for the user",
//                                                  Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.4),
//                                                  Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut]
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let rye = RyeViewController.init(dismissMode: .automatic(interval: 10),
//                                             viewType: .standard(configuration: ryeConfiguration),
//                                             at: .bottom(inset: 16),
//                                             timeAlive: 20)
//            rye.show()
//        }
//    }
//
//    private func displayCustomToast() {
//        // display Custom Rye
//
//        let customRyeView = RyeView()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let rye = RyeViewController.init(viewType: .custom(customRyeView),
//                                             at: .bottom(inset: 16),
//                                             timeAlive: 2)
//            rye.show()
//        }
//    }
    
    private func displayStandardRyeMessage() {
//        let ryeConfiguration: RyeConfiguration = [
//            Rye.Configuration.Key.text : "Plain old standard hello from rye",
//            Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.7),
//            Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut
//        ]
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let rye = RyeViewController(dismissMode: .gesture,
//                                        viewType: .standard(configuration: ryeConfiguration),
//                                        at: .top(inset: 0.0),
//                                        timeAlive: 5.0)
//            rye.show()
//        }
    }
    
    private func displayAutomaticMessage() {
        let timeInterval = 3.0
        let ryeConfiguration: RyeConfiguration = [
            Rye.Configuration.Key.text : "This message will self destruct after \(timeInterval) seconds",
            Rye.Configuration.Key.backgroundColor: UIColor.red.withAlphaComponent(0.7),
            Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut
        ]
        
        let rye = RyeViewController(dismissMode: .automatic(interval: 2.0),
                                    viewType: .standard(configuration: ryeConfiguration),
                                    at: .top(inset: 0.0))
        rye.show()
    }
    

    private func displayGestureMessage() {
        let ryeConfiguration: RyeConfiguration = [
            Rye.Configuration.Key.text : "Tap this message to dismiss it",
            Rye.Configuration.Key.backgroundColor: UIColor.lightGray.withAlphaComponent(0.7),
            Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut
        ]
        
        ryeViewController = RyeViewController(dismissMode: .gesture,
                                    viewType: .standard(configuration: ryeConfiguration),
                                    at: .bottom(inset: 0.0))
        ryeViewController?.show()
    }

    private func displayNonDismissableMessage() {
        let ryeConfiguration: RyeConfiguration = [
            Rye.Configuration.Key.text : "This message will stay till you tap the button again",
            Rye.Configuration.Key.backgroundColor: UIColor.blue.withAlphaComponent(0.7),
            Rye.Configuration.Key.animationType: Rye.AnimationType.fadeInOut
        ]
        
        ryeViewController = RyeViewController(dismissMode: .nonDismissable,
                                              viewType: .standard(configuration: ryeConfiguration),
                                    at: .top(inset: 0.0))
        ryeViewController?.show()
    }

    private func displayCustomRyeMessage() {
        let customRyeView = RyeButtonView.fromNib()
        customRyeView.delegate = self
//        let customRyeView = RyeImageView.fromNib()
        
        ryeViewController = RyeViewController(viewType: .custom(customRyeView, animationType: .fadeInOut),
                                    at: .bottom(inset: 0.0))
        ryeViewController?.show()
    }
    
    @IBAction func didTapAutomatic(_ sender: UIButton) {
        displayAutomaticMessage()
    }
    
    @IBAction func didTapGesture(_ sender: UIButton) {
        displayGestureMessage()
    }

    @IBAction func didTapNonDissmisable(_ sender: UIButton) {
        if isShowingNonDismissableMessage {
            ryeViewController?.dismiss()
        } else {
            displayNonDismissableMessage()
        }
        isShowingNonDismissableMessage.toggle()
    }
    
}

extension RyeDemoViewController: RyeButtonViewDelegate {
    func didTapButton(in sender: RyeButtonView) {
        ryeViewController?.dismiss()
    }
}

