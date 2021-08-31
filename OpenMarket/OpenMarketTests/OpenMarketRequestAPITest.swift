import XCTest

@testable import OpenMarket

class OpenMarketRequestAPITest: XCTestCase {

    // RequestCreateItem Test
    func test_encode_RequestCreateItem() {
        let newItme = RequestCreateItem(title: "newItem",
                                        descriptions: "newItem_descriptions",
                                        price: 10000,
                                        currency: "KRW",
                                        stock: 50000,
                                        discountedPrice: 8000,
                                        images: ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
                                        password: "0000")

        guard let _ = try? JSONEncoder().encode(newItme) else {
            XCTFail()
            return
        }
    }

    func test_RequestCreateItem_discountedPrice_is_nil() {
        let newItme = RequestCreateItem(title: "newItem",
                                        descriptions: "newItem_descriptions",
                                        price: 10000,
                                        currency: "KRW",
                                        stock: 50000,
                                        discountedPrice: nil,
                                        images: ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
                                        password: "0000")

        guard let _ = try? JSONEncoder().encode(newItme) else {
            XCTFail()
            return
        }
    }

    func test_RequestCreateItem_password_is_empty() {
        let newItme = RequestCreateItem(title: "newItem",
                                        descriptions: "newItem_descriptions",
                                        price: 10000,
                                        currency: "KRW",
                                        stock: 50000,
                                        discountedPrice: nil,
                                        images: ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
                                        password: "")

        guard let _ = try? JSONEncoder().encode(newItme) else {
            XCTFail()
            return
        }
    }

    // RequestUpdateItem Test
    func test_RequestUpdateItem_encode() {
        let updateItem = RequestUpdateItem(title: "newItem",
                                        descriptions: "newItem_descriptions",
                                        price: 10000,
                                        currency: "KRW",
                                        stock: 50000,
                                        discountedPrice: 6000,
                                        images: ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
                                        password: "")

        guard let _ = try? JSONEncoder().encode(updateItem) else {
            XCTFail()
            return
        }
    }

    func test_RequestUpdateItem_dicountedPrice_is_nil() {
        let updateItem = RequestUpdateItem(title: "newItem",
                                        descriptions: "newItem_descriptions",
                                        price: 10000,
                                        currency: "KRW",
                                        stock: 50000,
                                        discountedPrice: nil,
                                        images: ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
                                        password: "")

        guard let _ = try? JSONEncoder().encode(updateItem) else {
            XCTFail()
            return
        }
    }

    func test_RequestUpdateItem_password_is_empty() {
        let updateItem = RequestUpdateItem(title: "newItem",
                                        descriptions: "newItem_descriptions",
                                        price: 10000,
                                        currency: "KRW",
                                        stock: 50000,
                                        discountedPrice: nil,
                                        images: ["https://www.google.com/url?sa=i&url=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3ATest-Logo.svg&psig=AOvVaw2M6t5dGULeeIpuP8akpheQ&ust=1630483537398000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiKudPm2vICFQAAAAAdAAAAABAJ"],
                                        password: "")

        guard let _ = try? JSONEncoder().encode(updateItem) else {
            XCTFail()
            return
        }
    }

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
