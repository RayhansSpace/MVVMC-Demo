import Foundation

struct ApiResponse: Decodable {
    let collection: CollectionInfo
    let data: [Make]
}

struct CollectionInfo: Decodable {
    let url: String
    let count: Int
    let pages: Int
    let total: Int
    let next: String?
    let prev: String?
    let first: String
    let last: String
}

struct Make: Decodable, Hashable {
    let id: Int
    let name: String
}
