import Foundation

class ItemManager {
    let urlsessionProvider: URLSessionProvider
    var items: [Item] = []
    var lastPage = 1
    var delegate: ViewControllerDelegate?

    init(urlsession: URLSessionProvider) {
        self.urlsessionProvider = urlsession
    }

    // TODO : failure 에러 처리
    func readItems() {
        guard let delegate = self.delegate else { return }

        urlsessionProvider.getItems(page: self.lastPage) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodeData = try? JSONDecoder().decode(getItems.self, from: data) else { return }
                
                self?.items += decodeData.items
                self?.lastPage += 1

                DispatchQueue.main.async {
                    delegate.reloadCollectionView()
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}
