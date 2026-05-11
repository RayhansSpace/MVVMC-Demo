import SwiftUI
import Combine

class CarCoordinator: ObservableObject {
    
    private func createVC() -> some View {
        CarView()
    }
}

extension CarCoordinator {
    func start(with make: Make) -> some View { createVC() }
}
