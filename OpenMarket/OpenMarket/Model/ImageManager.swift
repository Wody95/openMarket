import UIKit

struct ImageFile {
    let image: UIImage
    let filename: String
    let data: Data
    let type: String
}

class ImageManager {
    private var images: [ImageFile] = []

    func imagesCount() -> Int {
        return images.count
    }

    func append(image: ImageFile) {
        self.images.append(image)
    }

    func imageFile(index: Int) -> ImageFile {
        return self.images[index]
    }

    func imageFiles() -> [ImageFile] {
        return self.images
    }

    func reset() {
        self.images = []
    }

    func isCompleteAddImage(_ resultsCount: Int) -> Bool {
        return resultsCount == self.images.count
    }
}
