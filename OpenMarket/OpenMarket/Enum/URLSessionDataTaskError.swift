import Foundation

enum URLSessionDataTaskError: Error {
    case unknownError
    case badURL
    case httpCodeError
    case dataError
    case bodyError
}
