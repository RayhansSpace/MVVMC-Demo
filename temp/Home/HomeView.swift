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
            
            ZStack {
                
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(errorMsg: error)
                } else {
                    VehicleList(content: viewModel.vehicleMakes) { vehicle in
                        didTapCell(vehicle.type, vehicle.make)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            FilterView(selected: $viewModel.filter) { filter in
                switch filter {
                case .car, .motorcycle :
                    viewModel.filter = filter
                    viewModel.filter(by: filter!)
                default:
                    viewModel.filter = nil
                    viewModel.loadVehicles()
                }
            }
            
        }.task { await viewModel.fetchVehicles() }
    }
}

struct LoadingView: View {
    
    var body: some View {
        Text("Loading...")
    }
}

struct FilterView: View {
    
    @Binding var selected: VehicleType?
    var didTapFilter: ((VehicleType?) -> Void)
    var body: some View {
        Picker("Filter", selection: $selected) {
            Text("All").tag(nil as VehicleType?)
            Text("Cars").tag(VehicleType.car as VehicleType?)
            Text("Motorcycles").tag(VehicleType.motorcycle as VehicleType?)
        }
        .pickerStyle(.segmented)
        .padding()
        .onChange(of: selected) { _, newValue in
            didTapFilter(newValue)
        }
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

struct VehicleListCell: Hashable {
    let type: VehicleType
    let make: Make
}

struct VehicleList: View {
    
    let content: [VehicleListCell]
    var didTapCell: ((VehicleListCell) -> Void )
    
    var body: some View {
        List(content, id: \.self) { cell in
            CustomCell(
                title: cell.make.name,
                systemImage: (cell.type == .car ? "car" : "motorcycle")
            )
            .onTapGesture { didTapCell(cell) }
        }
        .scrollContentBackground(.hidden)
    }
}

struct CustomCell: View {

    let title: String
    let systemImage: String
    var body: some View {

        HStack {

            Image(systemName: systemImage)
            Text(title)
            Spacer()
            
        }
        .padding()
        .background( Color(.systemGray6) )
        .cornerRadius(16)
        .shadow(
            color: .black.opacity(0.40),
            radius: 6,
            x: 0,
            y: 3
        )
    }
}
