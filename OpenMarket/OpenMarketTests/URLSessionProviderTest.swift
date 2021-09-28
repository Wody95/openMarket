//
//  URLSessionProviderTest.swift
//  OpenMarketTests
//
//  Created by 기원우 on 2021/09/07.
//

import XCTest

@testable import OpenMarket

class URLSessionProviderTest: XCTestCase {

    var sut: URLSessionProvider!

    // mock Response 세팅
    let successResponse = HTTPURLResponse(url: MockData().mockURL,
                                          statusCode: 200,
                                          httpVersion: "2", headerFields: nil)
    let failureResponse = HTTPURLResponse(url: MockData().mockURL,
                                          statusCode: 402,
                                          httpVersion: "2",
                                          headerFields: nil)

    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
    }

    func test_getItem_success() {
        // MockURLSession 세팅
        let mockSession = MockURLSession(isRequestSuccess: true)
        mockSession.successResponse = successResponse
        mockSession.failureResponse = failureResponse
        mockSession.resultData = MockData().mockGETItem!.data

        sut = URLSessionProvider(session: mockSession)

        // 결과값 response 불러오기
        let response = try? JSONDecoder().decode(ResponseItem.self,
                                                 from: MockData().mockGETItem!.data)

        // MockURLSession을 통해 테스트
        
        sut.getItem(id: 1) { result in
            switch result {
            case .success(let data):
                guard let item = try? JSONDecoder().decode(ResponseItem.self, from: data) else {
                    XCTFail("Decode Error")
                    return
                }
                XCTAssertEqual(item.id, response?.id)
                XCTAssertEqual(item.title, response?.title)
                XCTAssertEqual(item.price, response?.price)
                XCTAssertEqual(item.stock, response?.stock)
            case .failure(let error):
                XCTFail("getItem failure, error : \(error)")
            }
        }
    }

    func test_getItem_failure() {
        // MockURLSession 세팅
        // mockURLSession의 결과를 강제로 실패하도록 설정
        let mockSession = MockURLSession(isRequestSuccess: false)
        mockSession.successResponse = successResponse
        mockSession.failureResponse = failureResponse

        sut = URLSessionProvider(session: mockSession)

        // mockURLSession의 실패시 응답 코드가 402로 설정되었으므로 반환되는 에러는 httpCodeError
        sut.getItem(id: 1) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, URLSessionDataTaskError.httpCodeError)
            }
        }
    }

    func test_getItems_success() {
        // mockURLSessionProvider 세팅
        let mockSession = MockURLSession(isRequestSuccess: true)
        mockSession.successResponse = successResponse
        mockSession.failureResponse = failureResponse
        mockSession.resultData = MockData().mockGETItems!.data

        sut = URLSessionProvider(session: mockSession)

        // 결과값 response 불러오기
        let response = try? JSONDecoder().decode(getItems.self, from: MockData().mockGETItems!.data)

        // mockURLSession을 통해 테스트
        sut.getItems(page: 1) { result in
            switch result {
            case .success(let data):
                guard let resultJson = try? JSONDecoder().decode(getItems.self, from: data) else {
                XCTFail("Decode Error")
                return
                }
                XCTAssertEqual(resultJson.page, response?.page)
                XCTAssertEqual(resultJson.items[0].id, response?.items[0].id)
                XCTAssertEqual(resultJson.items[0].title, response?.items[0].title)

            case .failure(_):
                XCTFail("getItems failure")
            }
        }
    }

    func test_getItems_failure() {
        // MockURLSession 세팅
        // mockURLSession의 결과를 강제로 실패하도록 설정
        let mockSession = MockURLSession(isRequestSuccess: false)
        mockSession.successResponse = successResponse
        mockSession.failureResponse = failureResponse

        sut = URLSessionProvider(session: mockSession)

        // mockURLSession의 실패시 응답 코드가 402로 설정되었으므로 반환되는 에러는 httpCodeError
        sut.getItems(page: 1) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, URLSessionDataTaskError.httpCodeError)
            }
        }
    }
}
