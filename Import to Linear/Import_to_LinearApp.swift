import SwiftUI
import Apollo

class ApplicationState: ObservableObject {
    @Published var apolloClient: ApolloClient? = nil
}

@main
struct Import_to_LinearApp: App {
    var applicationState = ApplicationState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(applicationState)
        }
    }
}
