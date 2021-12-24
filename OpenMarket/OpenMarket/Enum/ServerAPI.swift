import Foundation

enum ServerAPI {
    case getItems, getItem, postItem, patchItem, deleteItem

    var path: String {
        switch self {
        case .getItems:
            return "items/"
        case .getItem:
            return "item/"
        case .postItem:
            return "item"
        case .patchItem:
            return "item/"
        case .deleteItem:
            return "item/"
        }
    }

    var method: String {
        switch self {
        case .getItems:
            return "GET"
        case .getItem:
            return "GET"
        case .postItem:
            return "POST"
        case .patchItem:
            return "PATCH"
        case .deleteItem:
            return "DELETE"
        }
    }
}
