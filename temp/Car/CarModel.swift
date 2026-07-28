import Foundation

struct CarModels: Fetchable {
    static let url = "https://carapi.app/api/models/v2?make="
    
    let collection: CollectionInfo
    let data: [VehicleModel]
}
