import Foundation

enum ImageType {
    case jpg, png

    var type: String {
        switch self {
        case .jpg:
            return "jpg"
        case .png:
            return "png"
        }
    }
}

struct ImageFile {
    let filename: String
    let data: Data
    let type: ImageType
}
