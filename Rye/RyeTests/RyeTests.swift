//
//  RyeTests.swift
//  RyeTests
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import XCTest
@testable import Rye
import Quick
import Nimble

class RyeTests: QuickSpec {
    override func spec() {
        describe("RyeDefaultView") {
            var defaultView: RyeDefaultView!
            var ryeConfiguration: RyeConfiguration!

            context("checkDefaultViewLabelText") {
                it("is equal") {
                    let text = "Mock Text"
                    ryeConfiguration = [Rye.Configuration.Key.text: text]
                    defaultView = RyeDefaultView(configuration: ryeConfiguration)
                    expect(defaultView.label.text).to(equal(text))
                }

                it("sets defaultText") {
                    let defaultText = "Add a message"
                    ryeConfiguration = [Rye.Configuration.Key.textFont: UIFont.systemFont(ofSize: 20, weight: .bold)]
                    defaultView = RyeDefaultView(configuration: ryeConfiguration)
                    expect(defaultView.label.text).to(equal(defaultText))
                }
            }
        }
    }
}
