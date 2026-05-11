import Foundation

class ApiService {
    
    func fetchCars() async throws -> [Make] {
        
        guard let url = URL(string: "https://carapi.app/api/makes/v2") else {
            throw ApiError.invalidURL
        }
        
        let (data ,_ ) = try await URLSession.shared.data(from: url)
        let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        
        return apiResponse.data
    }
    
    func fetchMotorcycles() async throws -> [Make] {
        
        guard let url = URL(string: "https://carapi.app/api/makes/powersports?type=street_motorcycle") else {
            throw URLError(.badURL)
        }
        
        let (data ,_ ) = try await URLSession.shared.data(from: url)
        let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        
        return apiResponse.data
    }
    
    func fecthModels(for make: Make) async throws -> [VehicleModel] {
        
        guard let url = URL(string: "https://carapi.app/api/models/powersports?type=street_motorcycle&make=\(make.name)") else {
            throw URLError(.badURL)
        }
        
        let (data ,_ ) = try await URLSession.shared.data(from: url)
        let apiResponse = try JSONDecoder().decode(VehicleModelApiResponse.self, from: data)
        
        return apiResponse.data
    }
}

enum ApiError: LocalizedError {
    
    case invalidURL
    case unexpectedError
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidURL:
            return "Invalid URL"
            
        case .unexpectedError:
            return "Unexpected Error"
        }
    }
}
