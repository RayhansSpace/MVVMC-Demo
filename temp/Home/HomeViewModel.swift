import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var vehicleMakes: [VehicleListCell] = []
    @Published var carMakes: [Make] = []
    @Published var motorcycleMakes: [Make] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var filter: VehicleType? = nil
    
    private let service: ApiService
    
    init(service: ApiService = .shared) {
        self.service = service
    }
    
    func loadVehicles() {
        
        vehicleMakes.removeAll()
        
        carMakes.forEach { car in
            vehicleMakes.append(VehicleListCell(type: .car, make: car))
        }
        
        motorcycleMakes.forEach { motorcycle in
            vehicleMakes.append(VehicleListCell(type: .motorcycle, make: motorcycle))
        }
        
        vehicleMakes.sort(using: KeyPathComparator(\.make.name))
        
    }
    
    func fetchVehicles() async {
                                                                                    // Kept them seperate for error handling purposes
        isLoading = true
        
        do {
            let carResponse: CarMakes = try await service.fetch()
            carMakes = carResponse.data
        } catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
        
        do {
            let motorcycleResponse: MotorcycleMakes = try await service.fetch()
            motorcycleMakes = motorcycleResponse.data
        } catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
        
        loadVehicles()
        
        try? await Task.sleep(for: .seconds(1.5))
        
        isLoading = false
    }
    
    func filter(by type: VehicleType) {
        loadVehicles()
        vehicleMakes = vehicleMakes.filter { $0.type == type }
    }
}
