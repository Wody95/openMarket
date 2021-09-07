//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/09/07.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

