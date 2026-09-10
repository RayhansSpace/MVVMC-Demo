import SwiftUI

struct HomeView: View {

    @State private var coordinator = HomeCoordinator()
    @State private var viewModel = HomeViewModel(service: ApiService.shared)

    var body: some View {

        NavigationStack(path: $coordinator.path) {                      //MARK: look into this

            ContentView(viewModel: viewModel) { vehicle , make in
                
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
    @Bindable var viewModel: HomeViewModel
    var didTapCell: ((VehicleType, Make) -> Void )

    var body: some View {
        
        VStack {
            
            Text("Select a vehicle")
                .modifier(TitleFormat())
            
            ZStack {
                
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(error: error)
                } else {
                    VehicleList(content: viewModel.vehicleMakes) { vehicle in
                        didTapCell(vehicle.type, vehicle.make)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            FilterView(selected: $viewModel.filter) { filter in
                switch filter {
                case .Car, .Motorcycle :
                    viewModel.filter = filter
                case .None:
                    viewModel.filter = .None
                case .Error:
                    Task { await viewModel.setError() }
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

enum FiltersEnum {
    case Car
    case Motorcycle
    case None
    case Error
}

struct FilterView: View {
    
    @Binding var selected: FiltersEnum
    var didTapFilter: ((FiltersEnum) -> Void)
    var body: some View {
        Picker("Filter", selection: $selected) {
            Text("All").tag(FiltersEnum.None as FiltersEnum)
            Text("Cars").tag(FiltersEnum.Car as FiltersEnum)
            Text("Motorcycles").tag(FiltersEnum.Motorcycle as FiltersEnum)
            Text("Error").tag(FiltersEnum.Error as FiltersEnum)
        }
        .pickerStyle(.segmented)
        .padding()
        .onChange(of: selected) { _, newValue in
            didTapFilter(newValue)
        }
    }
}

struct VehicleList: View {
    
    let content: [VehicleListCellModel]
    var didTapCell: ((VehicleListCellModel) -> Void )
    
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
