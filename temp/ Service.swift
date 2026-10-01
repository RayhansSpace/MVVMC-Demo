import Foundation

protocol VehicleServiceProtocol {
    func fetch<T:Fetchable>(make: Make?) async throws -> T
}

final class ApiService: VehicleServiceProtocol {
    
    static let shared = ApiService()
    
    func fetch<T: Fetchable>(make: Make?) async throws -> T {
        
        var urlString: String = T.url
        
        if let make { urlString = T.url + "\(make.name)" }
        
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
           
        let (data ,response ) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        
        if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
            throw ApiError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

protocol Fetchable: Decodable {
    static var url: String { get }
}


struct CarMakes: Fetchable {
    static let url = "https://carapi.app/api/makes/v2"
    
    let collection: CollectionInfo
    let data: [Make]
}

struct MotorcycleMakes: Fetchable {
    static let url = "https://carapi.app/api/makes/powersports?type=street_motorcycle"
    
    let collection: CollectionInfo
    let data: [Make]
}
