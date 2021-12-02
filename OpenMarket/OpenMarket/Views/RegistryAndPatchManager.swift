import Foundation

class RegistryAndPatchManager {
    let urlsessionProvider: URLSessionProvider
    var patchItem: ResponseItem?

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

    func patchItem(item: [String: Any], images: [ImageFile], completion: @escaping (ResponseItem) -> Void) {
        guard let id = self.patchItem?.id else { return }

        urlsessionProvider.patchItem(id: id, params: item, images: images) { result in
            switch result {

            case .success(let data):
                guard let response = try? JSONDecoder().decode(ResponseItem.self, from: data) else { return }
                completion(response)
            case .failure(let error):
                print("patchItem error code : \(error)")
            }
        }
    }
}
