import Foundation

class RegistryManager {
    let urlsessionProvider: URLSessionProvider

    init(urlsession: URLSessionProvider) {
        self.urlsessionProvider = urlsession
    }

    func registryItem(item: [String: Any], images: [ImageFile]) {
        urlsessionProvider.postItem(params: item, images: images) { result in
            switch result {

            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ResponseItem.self, from: data)
                    print(response)
                } catch {
                    print("decode Error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
