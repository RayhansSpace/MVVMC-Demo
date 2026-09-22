import Foundation

enum Route: Hashable {
    case car(Make)
    case motorcycle(Make)
    case truck(Make)
}

enum VehicleType {
    case car
    case motorcycle
}
