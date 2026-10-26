import Foundation

@MainActor
@Observable
class HomeViewModel {
    
    private let service: VehicleServiceProtocol
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
        
        vehicleMakes.sort {
            $0.make.name < $1.make.name
        }
        
    }
    
    func fetchVehicles() async {
                                                // MARK: Error handling (if one fails is the other lost?)
        isLoading = true
        
        defer {                                 // if cancels isLoading resets to false
                isLoading = false
            }
        
        do {
            async let carResponse: CarMakes = service.fetch(make: nil)
            async let motorcycleResponse: MotorcycleMakes = service.fetch(make: nil)

            let (cars, motorcycles) = try await (carResponse, motorcycleResponse)
            
            try Task.checkCancellation()        // check if cancelled

            carMakes = cars.data
            motorcycleMakes = motorcycles.data

        } catch is CancellationError {
            return
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
            let _: CarMakes = try await service.fetch(
                make: Make(id: 0, name: "Error")
            )
        } catch is CancellationError {
            return
        } catch let error as ApiError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = ApiError.unexpectedError.errorDescription
        }
    }
}
