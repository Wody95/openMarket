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

    func readItems() {
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
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    func downloadImage(index: Int) -> UIImage? {
        if (self.thumbnailImages[index] != nil) {
            return self.thumbnailImages[index]
        } else {
            let item = self.items[index]
            var result: UIImage?

            if let url = URL(string: item.thumbnails[0]),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {

                result = image
                self.thumbnailImages[index] = image
            }

            return result
        }
    }

    func deleteItem(index: Int) {
        self.items.remove(at: index)
        self.thumbnailImages.remove(at: index)
    }
}
