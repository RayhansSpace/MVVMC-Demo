import Foundation

@MainActor
@Observable
class HomeViewModel {
    
    var vehicleMakes: [VehicleListCellModel] = []
    var carMakes: [Make] = []
    var motorcycleMakes: [Make] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var filter: FiltersEnum = .None {
        didSet {
            errorMessage = nil
            filter(by: filter)
        }
    }
    
    private let service: VehicleServiceProtocol
    
    init(service: VehicleServiceProtocol) {
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
            let carResponse: CarMakes = try await service.fetch(make: nil)
            carMakes = carResponse.data
        } catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
        
        do {
            let motorcycleResponse: MotorcycleMakes = try await service.fetch(make: nil)
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
            let _: CarMakes = try await service.fetch(make: Make(id: 0, name: "Error"))
        }   catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
    }
}
