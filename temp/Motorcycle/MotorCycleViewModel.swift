import Foundation

@Observable
@MainActor
class MotorcycleViewModel {
    
    var models: [VehicleModel] = []
    var errorMessage: String? = nil
    private let make: Make
    private let service: ApiService
    
    init(service: ApiService = .shared, make: Make) {                  // MARK: why do i have to init why cant i just ViewModel(make: make)
        self.service = service
        self.make = make
    }
    
    func loadModels() async {
        
        do {
            let response: MotorcycleModels = try await service.fetch(make: make)
            models = response.data
        } catch { errorMessage = ApiError.unexpectedError.errorDescription }
    }
}
