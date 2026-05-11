import SwiftUI
import Combine

class MotorcycleCoordinator: ObservableObject {
    
    private func createVC(_ make: Make) -> some View {
        MotorcycleView(make: make)
    }
}

extension MotorcycleCoordinator {
    func start(with make: Make) -> some View { createVC(make) }
}
