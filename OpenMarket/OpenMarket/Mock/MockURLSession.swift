import UIKit

@available(iOS 14, *)
class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall()
    }
}

@available(iOS 14, *)
class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?
    var resultData: Data?
    var successResponse: HTTPURLResponse?
    var failureResponse: HTTPURLResponse?

    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let sessionDataTask = MockURLSessionDataTask()

        guard let resultData = self.resultData,
              let successResponse = self.successResponse,
              let failureResponse = self.failureResponse else { return sessionDataTask }

        if isRequestSuccess {
            sessionDataTask.resumeDidCall = { completionHandler(resultData, successResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil)
            }
        }

        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
