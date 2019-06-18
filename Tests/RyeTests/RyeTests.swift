import XCTest
@testable import l

final class RyeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Rye().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
