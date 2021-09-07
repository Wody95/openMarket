//
//  URLSessionModelTest.swift
//  OpenMarketTests
//
//  Created by 기원우 on 2021/09/07.
//

import XCTest

@testable import OpenMarket

class URLSessionModelTest: XCTestCase {

    let mockSession = MockURLSession()
    var sut: URLSessionModel!

    override func setUpWithError() throws {
        sut = .init(session: mockSession)
    }

    func test_getItem() {
        // 결과값 response 불러오기
        let response = try? JSONDecoder().decode(ResponseReadItem.self,
                                                 from: Sample().sampleItemData!.data)


        // 목업 URLSession을 통해 테스트
        sut.getItem(id: 1) { result in
            switch result {
            case .success(let data):
                guard let item = try? JSONDecoder().decode(ResponseReadItem.self, from: data) else {
                    XCTFail("Decode Error")
                    return
                }
                XCTAssertEqual(item.id, response?.id)
                XCTAssertEqual(item.title, response?.title)
                XCTAssertEqual(item.price, response?.price)
                XCTAssertEqual(item.stock, response?.stock)
            case .failure(_):
                XCTFail("getItem failure")
            }
        }
    }

    func test_getItem_failure() {
        // 목업 URLSession의 결과를 강제로 실패하도록 설정
        sut = URLSessionModel(session: MockURLSession(isRequestSuccess: false))

        // 목업 URLSession의 실패시 응답 코드가 402로 설정되었으므로 반환되는 에러는 httpCodeError
        sut.getItem(id: 1) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, URLSessionDataTaskError.httpCodeError)
            }
        }
    }
}
