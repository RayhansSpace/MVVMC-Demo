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
        List(viewModel.models, id: \.id) { model in
            HStack {
                Image(systemName: "motorcycle")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(model.name)
            }
        }
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(make.name)
                    .modifier(TitleFormat())
            }
        }
        .toolbarBackground(.white, for: .automatic)
        .task { await viewModel.loadModels()} }
}
