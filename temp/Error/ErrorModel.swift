import Foundation

enum ApiError: LocalizedError {
    
    case invalidURL
    case unexpectedError
    case invalidResponse
    case httpError(statusCode: Int)
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidURL:
            return "Invalid URL"
            
        case .unexpectedError:
            return "Selected Make Doesnt Exist!"
            
        case .invalidResponse:
            return "Invalid HTTP Response"
            
        case .httpError:
            return "HTTP Error"
        }
    }
}
