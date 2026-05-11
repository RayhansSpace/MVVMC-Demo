import Combine

class MotorcycleViewModel: ObservableObject {
    
    @Published var models: [VehicleModel] = []
    @Published var errorMessage: String? = nil
    let make : Make
    let service = ApiService()
    
    init(make: Make) {                  // MARK: why do i have to init why cant i just ViewModel(make: make)
        self.make = make
    }
    
    func loadModels() async {
        
        do {
            models = try await service.fecthModels(for: make)
        } catch { errorMessage = ApiError.unexpectedError.errorDescription }
    }
}
