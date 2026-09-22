import SwiftUI

class AppRouteBuilder {
    
    static func build(_ route: Route) ->  AnyView {
        switch route {
        case .car(let make):
            return AnyView(CarCoordinator().start(with: make))
        case .motorcycle(let make):
            return AnyView(MotorcycleCoordinator().start(with: make))
        case .truck(let make):
            return AnyView(TruckCoordinator().start(with: make))
        }
    }
}

class TruckCoordinator {
    private func createView() -> some View {
        Text("Truck")
    }
}

extension TruckCoordinator {
    
    func start(with make: Make) -> some View  {
        createView()
    }
}


protocol NormalDrivingLicense {
    func drivingLicenseType() -> DrivingLicense
}

enum DrivingLicense {
    case Normal
    case Special
}
