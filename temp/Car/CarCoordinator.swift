import SwiftUI

class CarCoordinator: NormalDrivingLicense {
    
    func drivingLicenseType() -> DrivingLicense {
        DrivingLicense.Normal
    }
    
    
    private func createView(_ make: Make) -> some View {
        CarView(make: make)
    }
}

extension CarCoordinator {
    func start(with make: Make) -> some View { createView(make) }
}
