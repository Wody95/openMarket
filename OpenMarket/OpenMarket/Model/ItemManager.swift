import UIKit

class ItemManager {
    let urlsessionProvider: URLSessionProvider
    var items: [Item] = []
    var thumbnailImages: [UIImage?] = []
    var lastPage = 1
    var delegate: ItemListViewControllerDelegate?

    init(urlsession: URLSessionProvider) {
        self.urlsessionProvider = urlsession
    }

    func readItems(completion: (() -> Void)? = nil) {
        guard let delegate = self.delegate else { return }

        urlsessionProvider.getItems(page: self.lastPage) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodeData = try? JSONDecoder().decode(getItems.self, from: data) else { return }
                
                self?.items += decodeData.items
                self?.lastPage += 1

                if decodeData.items.count >= 1 {
                    for _ in 1...decodeData.items.count {
                        self?.thumbnailImages.append(nil)
                    }
                }

                DispatchQueue.main.async {
                    delegate.reloadCollectionView()
                    completion?()
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    func updateItems(completion: @escaping () -> Void) {
        items = []
        thumbnailImages = []
        lastPage = 1

        readItems(completion: completion)
    }

    func downloadImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        if self.thumbnailImages[index] != nil {
            completion(self.thumbnailImages[index])
        }

        let url = self.items[index].thumbnails[0]

        urlsessionProvider.downloadImage(url: url) { resultData in
            switch resultData {

            case .success(let data):
                let image = UIImage(data: data)
                self.thumbnailImages[index] = image
                completion(image)

            case .failure(let error):
                print(error)
            }
        }
    }

    func setupItemManager() {
        if items.count == 0 {
            readItems(completion: nil)
        }
    }

}

