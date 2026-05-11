import SwiftUI

struct HomeView: View {

    @StateObject private var coordinator = HomeCoordinator()

    var body: some View {

        NavigationStack(path: $coordinator.path) {                      //MARK: look into this

            ContentView { vehicle , make in
                
                switch vehicle {
                case .car:
                    coordinator.push(.car(make))
                case .motorcycle:
                    coordinator.push(.motorcycle(make))
                }
            }
            .navigationDestination(for: Route.self) { route in
                coordinator.build(route)
            }
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = HomeViewModel()
    var didTapCell: ((VehicleType, Make) -> Void )

    var body: some View {
        VStack {
            
            TitleView()
            
            if viewModel.carsLoading {
                LoadingView()
            } else if let error = viewModel.errorMessage {
                ErrorView(errorMsg: error)
            } else {
                CarsList(makes: viewModel.carMakes) { make in didTapCell(.car, make) }
            } // MARK: is this how im suposed to do it
            
            if viewModel.motorcyclesLoading {
                LoadingView()
            } else if let error = viewModel.errorMessage {
                ErrorView(errorMsg: error)
            } else {
                MotorcyclesList(makes: viewModel.motorcycleMakes) { make in didTapCell(.motorcycle, make) }
            }
        }
        .padding()
        .task {
            await viewModel.loadCars()
            await viewModel.loadMotorcycles()
        }
    }
}

struct LoadingView: View {
    
    var body: some View {
        Text("Loading...")
    }
}

struct ErrorView: View {
    
    let errorMsg: String
    
    var body: some View {
        Text(errorMsg)
    }
}

struct TitleView: View {
    
    var body: some View {
        Text("Vehicles")
            .font(.largeTitle)
            .fontWeight(.heavy)
    }
}

struct CarsList: View {
    
    let makes: [Make]
    var didTapCell: ((Make) -> Void )
    
    var body: some View {
        List(makes, id: \.id) { make in
            HStack {
                Image(systemName: "car")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(make.name)
            }
            .onTapGesture { didTapCell(make) }
        }
        .scrollContentBackground(.hidden)
    }
}

struct MotorcyclesList: View {
    
    let makes: [Make]
    var didTapCell: ((Make) -> Void )
    
    var body: some View {
        List(makes, id: \.id) { make in
            
            CustomCell(
                title: make.name,
                systemImage: "motorcycle"
            )
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .onTapGesture { didTapCell(make) }
        }
        .scrollContentBackground(.hidden)
    }
}

struct CustomCell: View {

    let title: String
    let systemImage: String

    var body: some View {

        HStack(spacing: 16) {

            Image(systemName: systemImage)
                .font(.title2)

            Text(title)
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(
            Color(.systemGray6)
        )
        .cornerRadius(16)
        .shadow(
            color: .black.opacity(0.40),
            radius: 6,
            x: 0,
            y: 3
        )
    }
}
