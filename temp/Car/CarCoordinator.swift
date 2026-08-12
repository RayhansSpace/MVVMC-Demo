import SwiftUI
import Combine

class CarCoordinator: ObservableObject {
    
    private func createVC(_ make: Make) -> some View {
        CarView(make: make)
    }
}

extension CarCoordinator {
    func start(with make: Make) -> some View { createVC(make) }
}
