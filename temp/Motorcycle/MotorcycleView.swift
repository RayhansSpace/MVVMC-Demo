import SwiftUI
import Combine

struct MotorcycleView: View {
    
    let make: Make
    @StateObject var viewModel: MotorcycleViewModel
    
    init(make: Make) {
        self.make = make
        _viewModel = StateObject(wrappedValue:  MotorcycleViewModel(make: make)) // MARK: HELP !
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "motorcycle")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(make.name)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
            }
            
            List(viewModel.models, id: \.id) { model in
                HStack {
                    Image(systemName: "motorcycle")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text(model.name)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .task {
            await viewModel.loadModels()
        }
    }
}
