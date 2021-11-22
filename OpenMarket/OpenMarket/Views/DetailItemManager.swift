import UIKit

class DetailItemManager {
    let item: ResponseItem
    private let session: URLSessionProvider
    private(set) var images: [UIImage?] = []

    init(item: ResponseItem, session: URLSessionProvider) {
        self.item = item
        self.session = session

        setupImageNil()
    }

    private func setupImageNil() {
        for _ in 0..<item.images.count {
            images.append(nil)
        }
    }

    func downloadImages(completionHandler: @escaping () -> Void) {
        let lastIndex = images.count - 1

        for index in 0...lastIndex {
            let url = item.images[index]

            session.downloadImage(url: url) { [weak self] result in
                guard let self = self else { return }
                switch result {

                case .success(let data):
                    let image = UIImage(data: data)
                    self.images[index] = image

                    if index == lastIndex {
                        completionHandler()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}
