import SwiftUI

struct ErrorView: View {
    let error: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)

            Text("Something went wrong")
                .font(.headline)

            Text(error)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}


