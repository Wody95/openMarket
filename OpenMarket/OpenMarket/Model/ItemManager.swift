import Foundation

class ItemManager {
    let urlsessionProvider: URLSessionProvider
    var items: [Item] = []

    init(urlsession: URLSessionProvider) {
        self.urlsessionProvider = urlsession
    }

    // TODO : failure 에러 처리
    func readItems(page: Int) {
        urlsessionProvider.getItems(page: page) { result in
            switch result {
            case .success(let data):
                guard let decodeData = try? JSONDecoder().decode(getItems.self, from: data) else { return }
                self.items += decodeData.items
            case .failure(let error):
                print(error)
            }
        }
    }
}
