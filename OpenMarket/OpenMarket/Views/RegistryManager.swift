import Foundation

class RegistryManager {
    let urlsessionProvider: URLSessionProvider

    init(urlsession: URLSessionProvider) {
        self.urlsessionProvider = urlsession
    }

    func registryItem(item: [String: Any], images: [ImageFile], completion: @escaping (ResponseItem) -> Void) {

        urlsessionProvider.postItem(params: item, images: images) { result in
            switch result {

            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ResponseItem.self, from: data)
                    completion(response)
                } catch {
                    print("decode Error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
