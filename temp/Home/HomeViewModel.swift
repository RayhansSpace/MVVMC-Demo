import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var vehicleMakes: [VehicleListCell] = []
    @Published var carMakes: [Make] = []
    @Published var motorcycleMakes: [Make] = []
    @Published var vehiclesLoading: Bool = false
    @Published var carsLoading: Bool = false
    @Published var motorcyclesLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var filter: VehicleType? = nil
    
    private let service = ApiService()
    
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
        
        vehiclesLoading = true
        
        await fetchCars()
        await fetchMotorcycles()
        loadVehicles()
        
        try? await Task.sleep(for: .seconds(3))
        
        vehiclesLoading = false
    }
    
    func fetchCars() async {
        
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
    
    func fetchMotorcycles() async {
        
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
    
    func filter(by type: VehicleType) {
        loadVehicles()
        vehicleMakes = vehicleMakes.filter { $0.type == type }
    }
}
