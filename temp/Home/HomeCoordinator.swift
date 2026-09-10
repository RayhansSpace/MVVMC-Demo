import SwiftUI
import Combine

@Observable
@MainActor
class HomeCoordinator {
    
    var path = NavigationPath()
    
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

enum Route: Hashable {
    case car(Make)
    case motorcycle(Make)
}
