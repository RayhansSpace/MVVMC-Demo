import SwiftUI

struct TitleFormat: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.bold)
            .padding()
            .foregroundStyle(.white)
            .background(.black)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.top,30)
            .padding(.bottom,15)
    }
}
