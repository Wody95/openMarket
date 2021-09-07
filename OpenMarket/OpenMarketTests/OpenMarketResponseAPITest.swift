import XCTest

@testable import OpenMarket

class OpenMarketResponseAPITest: XCTestCase {

    func test_ResponseReadItems_decode() {
        guard let json = NSDataAsset(name: "Items") else {
            XCTFail()
            print("load Asset Data error")
            return
        }

        guard let _ = try? JSONDecoder().decode(ResponseReadItems.self,
                                                from: json.data) else {
            XCTFail()
            print("Decode error")
            return
        }
    }

    func test_ResponseReadItem_decode() {
        guard let json = NSDataAsset(name: "Item") else {
            XCTFail()
            print("load Asset Data error")
            return
        }

        guard let _ = try? JSONDecoder().decode(ResponseReadItem.self,
                                                from: json.data) else {
            XCTFail()
            print("Decode error")
            return
        }
    }
}
