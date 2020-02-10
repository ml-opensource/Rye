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
            let text = "Message for the user"

            beforeEach {
                ryeConfiguration = [Rye.Configuration.Key.text: text]
                defaultView = RyeDefaultView(configuration: ryeConfiguration)
            }

            context("checkDefaultViewLabelText") {
                it("is equal") {
                    expect(defaultView.label.text).to(equal(text))
                }
            }
        }
    }
}
