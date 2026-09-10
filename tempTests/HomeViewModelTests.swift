import Testing
@testable import temp

@MainActor
struct HomeViewModelTests {

    @Test
    func fetchVehichles_success() async throws {
        let mockService = MockService()
        
        mockService.carMakes = [
            Make(id: 1, name: "Audi"),
            Make(id: 2, name: "BMW")
        ]

        mockService.motorcycleMakes = [
            Make(id: 3, name: "Honda"),
            Make(id: 4, name: "Yamaha")
        ]

        let viewModel = HomeViewModel(service: mockService)

        await viewModel.fetchVehicles()

        #expect(viewModel.carMakes.count == 2)
        #expect(viewModel.motorcycleMakes.count == 2)

        #expect(viewModel.carMakes[0].name == "Audi")
        #expect(viewModel.carMakes[1].name == "BMW")

        #expect(viewModel.motorcycleMakes[0].name == "Honda")
        #expect(viewModel.motorcycleMakes[1].name == "Yamaha")
        
    }
    
    @Test
    func fetchVehichles_failure() async throws {
        let mockService = MockService()
        mockService.error = ApiError.invalidURL
        
        let viewModel = HomeViewModel(service: mockService)
        
        await viewModel.fetchVehicles()
        #expect(viewModel.errorMessage == ApiError.invalidURL.errorDescription)
    }

}

final class MockService: VehicleServiceProtocol {

    var carMakes: [Make] = []
    var motorcycleMakes: [Make] = []
    var error: Error?

    func fetch<T: Fetchable>(make: Make?) async throws -> T {
        if let error {
            throw error
        }

        let collection = CollectionInfo(
            url: "",
            count: 0,
            pages: 1,
            total: 0,
            next: nil,
            prev: nil,
            first: "",
            last: ""
        )

        if T.self == CarMakes.self {
            return CarMakes(
                collection: collection,
                data: carMakes
            ) as! T
        }

        if T.self == MotorcycleMakes.self {
            return MotorcycleMakes(
                collection: collection,
                data: motorcycleMakes
            ) as! T
        }

        fatalError("Unexpected type: \(T.self)")
    }
}
