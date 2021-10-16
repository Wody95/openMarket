import Foundation

class URLSessionProvider {
    let session: URLSessionProtocol
    let baseURL = "https://camp-open-market-2.herokuapp.com/"

    init(session: URLSessionProtocol = URLSession.shared) {
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
            for image in images {
                body.append(boundaryPrefix.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"\(image.filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/\(image.type)\r\n\r\n".data(using: .utf8)!)
                body.append(image.data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
 
        body.append(boundaryPrefix.data(using: .utf8)!)

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

    func postItem(params: [String: Any], images: [ImageFile], completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: baseURL + ServerAPI.postItem.path) else {
            return completionHandler(.failure(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = ServerAPI.postItem.method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: params, boundary: boundary, images: images)

        dataTask(request: request, completionHandler: completionHandler)
    }

    func patchItem(id: Int, params: [String: Any], images: [ImageFile]?, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: baseURL + ServerAPI.patchItem.path + "\(id)") else {
            return completionHandler(.failure(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = ServerAPI.patchItem.method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: params, boundary: boundary, images: images)

        dataTask(request: request, completionHandler: completionHandler)
    }

    func deleteItem(id: Int, password: String, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {
        let deleteData = OpenMarket.deleteItem(password: password)

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

    func downloadImage(url: String, completionHandler: @escaping (Result<Data, URLSessionDataTaskError>) -> Void) {
        guard let url = URL(string: url) else { return completionHandler(.failure(.badURL)) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        dataTask(request: request, completionHandler: completionHandler)
    }
}
