import SwiftUI



struct practiseView: View {
    
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path) {
            VStack {
                Button("Red") {
                    path.append(Routes1.RedPage)
                }
                Button("Blue") {
                    path.append(Routes1.BluePage)
                }
                Button("Green"){
                    path.append(Routes1.GreenPage)
                }
            }
        }
        .navigationDestination(for: Routes1.self) { route in
            
            
        }
    }
}


enum Routes1: Hashable {
    case GreenPage
    case BluePage
    case RedPage
}

