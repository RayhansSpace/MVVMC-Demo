import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var carMakes: [Make] = []
    @Published var motorcycleMakes: [Make] = []
    @Published var carsLoading: Bool = false
    @Published var motorcyclesLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service = ApiService()
    
    func loadCars() async {
        
        carsLoading = true
        
        do {
            carMakes = try await service.fetchCars()
        } catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
        
        carsLoading = false
        
    }
    
    func loadMotorcycles() async {
        
        motorcyclesLoading = true
        
        do {
            motorcycleMakes = try await service.fetchMotorcycles()
        } catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
        
        motorcyclesLoading = false
    }
}
