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

    func test_ResponseCreateItem_decode() {
        guard let json = """
        {
            "id": 1,
            "title": "newItem",
            "descriptions": "newItem_descriptions",
            "price": 10000,
            "currency": "KRW",
            "stock": 50000,
            "discounted_price": 8000,
            "thumbnails": ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
            "images": ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
            "registration_date": 1611523563.719116
        }
        """.data(using: .utf8) else {
            XCTFail()
            print("Encoding Json Error")
            return
        }

        guard let _ = try? JSONDecoder().decode(ResponseCreateItem.self,
                                                from: json) else {
            XCTFail()
            print("Decode error")
            return
        }
    }

    func test_ResponseUpdateItem_decode() {
        guard let json = """
        {
            "id": 1,
            "title": "updateItem",
            "descriptions": "updateItem_descriptions",
            "price": 20000,
            "currency": "KRW",
            "stock": 50000,
            "discounted_price": 8000,
            "thumbnails": ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
            "images": ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
            "registration_date": 1611523563.719116
        }
        """.data(using: .utf8) else {
            XCTFail()
            print("Encoding Json Error")
            return
        }

        guard let _ = try? JSONDecoder().decode(ResponseUpdateItem.self,
                                                from: json) else {
            XCTFail()
            print("Decode error")
            return
        }
    }

    func test_ResponseDeleteItem_decode() {
        guard let json = """
        {
            "id": 1,
            "title": "deleteItem",
            "descriptions": "deleteItem_descriptions",
            "price": 10000,
            "currency": "KRW",
            "stock": 50000,
            "discounted_price": 8000,
            "thumbnails": ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
            "images": ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
            "registration_date": 1611523563.719116
        }
        """.data(using: .utf8) else {
            XCTFail()
            print("Encoding Json Error")
            return
        }

        guard let _ = try? JSONDecoder().decode(ResponseDeleteItem.self,
                                                from: json) else {
            XCTFail()
            print("Decode error")
            return
        }
    }
}
