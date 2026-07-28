import Foundation

struct VehicleModel: Decodable {
    let id: Int
    let make_id: Int
    let name : String
    let make: String
}

struct MotorcycleModels: Fetchable {
    static let url = "https://carapi.app/api/models/powersports?type=street_motorcycle&make="
    
    let collection: CollectionInfo
    let data: [VehicleModel]
}
