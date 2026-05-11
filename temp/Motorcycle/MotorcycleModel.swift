import Foundation

struct VehicleModelApiResponse: Decodable {
    let collection: CollectionInfo
    let data: [VehicleModel]
}

struct VehicleModel: Decodable {
    let id: Int
    let make_id: Int
    let name : String
    let make: String
}
