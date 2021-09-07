//
//  URLSession.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/09/02.
//

import Foundation

enum URLSessionDataTaskError: Error {
    case unknownError
    case httpCodeError
    case dataError
}

class URLSessionModel {

    private let session: URLSession
    private let baseURL = "https://camp-open-market-2.herokuapp.com/"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {

        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return completionHandler(.failure(.unknownError))
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.httpCodeError))
            }

            if let data = data {
                return completionHandler(.success(data))
            } else {
                return completionHandler(.failure(.dataError))
            }
        }
        task.resume()
    }
}
