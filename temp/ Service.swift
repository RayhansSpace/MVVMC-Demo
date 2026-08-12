import Foundation

final class ApiService {
    
    static let shared = ApiService()
    
    func fetch<T: Fetchable>(make: Make? = nil) async throws -> T {
        
        var urlString: String = T.url
        
        if let make { urlString = T.url + "\(make.name)" }
        
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
           
        let (data ,_ ) = try await URLSession.shared.data(from: url)
        let apiResponse = try JSONDecoder().decode(T.self, from: data)
        
        return apiResponse
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
