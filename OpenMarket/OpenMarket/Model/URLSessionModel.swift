//
//  URLSession.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/09/02.
//

import Foundation

enum URLSessionDataTaskError: Error {
    case unknownError
    case badURL
    case httpCodeError
    case dataError
}

enum ServerAPI {
    case getItems, getItem, postItem, patchItem, deleteItem

    var path: String {
        switch self {
        case .getItems:
            return "items/"
        case .getItem:
            return "item/"
        case .postItem:
            return "item"
        case .patchItem:
            return "item/"
        case .deleteItem:
            return "item/"
        }
    }

    var method: String {
        switch self {
        case .getItems:
            return "GET"
        case .getItem:
            return "GET"
        case .postItem:
            return "POST"
        case .patchItem:
            return "PATCH"
        case .deleteItem:
            return "DELETE"
        }
    }
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

    func createBody(parameters: [String: Any], boundary: String, images: [ImageFile]?) -> Data {

        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in parameters {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        if let images = images {
            for (index, image) in images.enumerated() {
                body.append(boundaryPrefix.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"images[\(index)]\"; filename=\"\(image.filename)\"\\r\n\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/\(image.type)\r\n\r\n".data(using: .utf8)!)
                body.append(image.data)
            }
        }

        body.append("\r\n\(boundaryPrefix)".data(using: .utf8)!)

        return body
    }

    func getItems(page: Int, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {

        guard let url = URL(string: baseURL + ServerAPI.getItems.path + "\(page)") else {
            return completionHandler(.failure(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = ServerAPI.getItems.method

        dataTask(request: request, completionHandler: completionHandler)
    }

    func getItem(id: Int, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {

        guard let url = URL(string: baseURL + ServerAPI.getItem.path + "\(id)") else {
            return completionHandler(.failure(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = ServerAPI.getItem.method

        dataTask(request: request, completionHandler: completionHandler)
    }

    func requestItem(params: [String: Any], images: [ImageFile], serverAPI: ServerAPI, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {

        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: baseURL + serverAPI.path) else {
            return completionHandler(.failure(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = serverAPI.method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: params, boundary: boundary, images: images)

        dataTask(request: request, completionHandler: completionHandler)
    }

    func deleteItem(id: Int, password: String, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void ) {

        let deleteData = RequestDeleteItem(password: password)

        guard let json = try? JSONEncoder().encode(deleteData) else {
            return completionHandler(.failure(.unknownError))
        }

        guard let url = URL(string: baseURL + ServerAPI.deleteItem.path + "\(id)") else {
            return completionHandler(.failure(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = ServerAPI.deleteItem.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json

        dataTask(request: request, completionHandler: completionHandler)
    }
}
