//
//  RyeTests.swift
//  RyeTests
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import XCTest
@testable import Rye


class RyeTests: XCTestCase {
    
    var defaultView: RyeDefaultView!
    var ryeConfiguration: RyeConfiguration!
        
    func testCanDisplayDefaultMessage() {
        let defaultText = "Add a message"
        ryeConfiguration = [Rye.Configuration.Key.textFont: UIFont.systemFont(ofSize: 20, weight: .bold)]
        defaultView = RyeDefaultView()
        defaultView = RyeDefaultView(configuration: ryeConfiguration)
        XCTAssertEqual(defaultView.label.text, defaultText)
    }
    
    func testCanDisplayCustomMessage() {
        let text = "Custom Text Here"
        ryeConfiguration = [Rye.Configuration.Key.text: text]
        defaultView = RyeDefaultView(configuration: ryeConfiguration)
        XCTAssertEqual(defaultView.label.text, text)
    }
}
