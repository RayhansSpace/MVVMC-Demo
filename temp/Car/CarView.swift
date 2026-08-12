import SwiftUI
import Combine

struct CarView: View {
    
    let make: Make
    @StateObject var viewModel: CarViewModel
    
    init(make: Make) {
        self.make = make
        _viewModel = StateObject(wrappedValue:  CarViewModel(make: make)) // MARK: HELP !
    }
    
    var body: some View {
        List(viewModel.models, id: \.id) { model in
            HStack {
                Image(systemName: "car")
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

