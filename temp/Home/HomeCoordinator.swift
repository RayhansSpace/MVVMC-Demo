import SwiftUI
import Combine

class HomeCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    @ViewBuilder
    func build(_ route: Route) -> some View {
        switch route {
        case .car(let make):
            CarCoordinator().start(with: make)
        case .motorcycle(let make):
            MotorcycleCoordinator().start(with: make)
        }
    }
}

enum VehicleType {
    case car
    case motorcycle
}

enum Route: Hashable {
    case car(Make)
    case motorcycle(Make)
}
