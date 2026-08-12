import Foundation

enum ApiError: LocalizedError {
    
    case invalidURL
    case unexpectedError
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidURL:
            return "Invalid URL"
            
        case .unexpectedError:
            return "Selected Make Doesnt Exist!"
        }
    }
}
