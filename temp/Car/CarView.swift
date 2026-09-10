import SwiftUI

struct CarView: View {
    
    let make: Make
    var viewModel: CarViewModel
    
    init(make: Make) {
        self.make = make
        viewModel = CarViewModel(make: make)
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

