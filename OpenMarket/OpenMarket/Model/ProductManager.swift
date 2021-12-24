import Foundation

class ProductManager {
    let urlsessionProvider: URLSessionProvider
    var items: [Product] = []

    init(urlsession: URLSessionProvider) {
        self.urlsessionProvider = urlsession
    }

    // TODO : failure 에러 처리
    func readItems(page: Int) {
        urlsessionProvider.getProducts(page: page) { result in
            switch result {
            case .success(let data):
                guard let decodeData = try? JSONDecoder().decode(getProducts.self, from: data) else { return }
                self.items += decodeData.products
            case .failure(let error):
                print(error)
            }
        }
    }
}
