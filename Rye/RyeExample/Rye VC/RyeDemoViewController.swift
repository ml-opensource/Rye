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
    }
        
    private func displayAutomaticMessage() {
        let ryeConfiguration: RyeConfiguration = [
            .text : "This message will self destruct after \(Rye.defaultDismissInterval) seconds",
            .backgroundColor: UIColor.red.withAlphaComponent(0.7),
            .animationType: Rye.AnimationType.slideInOut
        ]
        
        ryeViewController = RyeViewController(dismissMode: .automatic(interval: Rye.defaultDismissInterval),
                                    viewType: .standard(configuration: ryeConfiguration),
                                    at: .top(inset: 40.0))
        ryeViewController?.show(withDismissCompletion: {
            self.ryeViewController = nil
        })
    }
    

    private func displayGestureMessage() {
        let ryeConfiguration: RyeConfiguration = [
            .text : "Tap or swipe this message to dismiss it",
            .backgroundColor: UIColor.lightGray.withAlphaComponent(0.7),
            .animationType: Rye.AnimationType.slideInOut
        ]
        
        ryeViewController = RyeViewController(dismissMode: .gesture,
                                    viewType: .standard(configuration: ryeConfiguration),
                                    at: .top(inset: 0.0))
        ryeViewController?.show(withDismissCompletion: {
            self.ryeViewController = nil
        })
    }

    private func displayNonDismissableMessage() {
        let ryeConfiguration: RyeConfiguration = [
            .text : "This message will stay till you tap the button again",
            .backgroundColor: UIColor.blue.withAlphaComponent(0.7),
            .animationType: Rye.AnimationType.fadeInOut
        ]
        
        ryeViewController = RyeViewController(dismissMode: .nonDismissable,
                                              viewType: .standard(configuration: ryeConfiguration),
                                    at: .top(inset: 0.0))
        ryeViewController?.show(withDismissCompletion: {
            self.ryeViewController = nil
        })
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

