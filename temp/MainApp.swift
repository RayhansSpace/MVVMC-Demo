import SwiftUI

@main
struct MainApp: App {
    @StateObject private var coordinator = HomeCoordinator()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
