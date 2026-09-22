import SwiftUI

class MotorcycleCoordinator: NormalDrivingLicense {
    func drivingLicenseType() -> DrivingLicense {
        return DrivingLicense.Normal
    }
    
    
    private func createView(_ make: Make) -> some View {
        MotorcycleView(make: make)
    }
}

extension MotorcycleCoordinator {
    func start(with make: Make) -> some View { createView(make) }
}
