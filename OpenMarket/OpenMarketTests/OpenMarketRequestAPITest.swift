import XCTest

@testable import OpenMarket

class OpenMarketRequestAPITest: XCTestCase {

    // RequestDeleteItem Test
    func test_RequestDeleteItem_encode() {
        let deleteItem = RequestDeleteItem(password: "0000")

        guard let _ = try? JSONEncoder().encode(deleteItem) else {
            XCTFail()
            return
        }
    }

    func test_RequestDeleteItem_password_is_empty() {
        let deleteItem = RequestDeleteItem(password: "")

        guard let _ = try? JSONEncoder().encode(deleteItem) else {
            XCTFail()
            return
        }
    }
}
