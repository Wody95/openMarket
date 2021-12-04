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
        var completionCount = 0

        for index in 0...lastIndex {
            let url = item.images[index]

            session.downloadImage(url: url) { [weak self] result in
                guard let self = self else { return }
                switch result {

                case .success(let data):
                    let image = UIImage(data: data)
                    self.images[index] = image
                    completionCount += 1

                    if completionCount == self.images.count {
                        completionHandler()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func deleteItem(password: String, completion: @escaping (Result<ResponseItem, URLSessionDataTaskError>) -> Void) {
        session.deleteItem(id: self.item.id, password: password) { result in
            switch result {

            case .success(let data):
                guard let response = try? JSONDecoder().decode(ResponseItem.self, from: data) else { return }
                completion(.success(response))

            case .failure(let error):
                print("deleteItem error: \(error)")
                completion(.failure(error))
            }
        }
    }

}
