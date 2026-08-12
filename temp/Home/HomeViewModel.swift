import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var vehicleMakes: [VehicleListCellModel] = []
    @Published var carMakes: [Make] = []
    @Published var motorcycleMakes: [Make] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var filter: FiltersEnum = .None {
        didSet {
            errorMessage = nil
            filter(by: filter)
        }
    }
    
    private let service: ApiService
    
    init(service: ApiService = .shared) {
        self.service = service
    }
    
    func loadVehicles() {
        
        vehicleMakes.removeAll()
        
        carMakes.forEach { car in
            vehicleMakes.append(VehicleListCellModel(type: .car, make: car))
        }
        
        motorcycleMakes.forEach { motorcycle in
            vehicleMakes.append(VehicleListCellModel(type: .motorcycle, make: motorcycle))
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
    
    func filter(by type: FiltersEnum) {
        loadVehicles()
        switch type {
        case .Car: vehicleMakes = vehicleMakes.filter { $0.type == .car }
        case .Motorcycle: vehicleMakes = vehicleMakes.filter { $0.type == .motorcycle }
        case .Error: break
        case .None: break
        }
    }
    
    func setError() async {
        do {
            let error: CarMakes = try await service.fetch(make: Make(id: 0, name: "Error"))
        }   catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
    }
}
