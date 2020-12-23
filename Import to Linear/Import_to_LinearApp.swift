import SwiftUI
import Apollo
import Alamofire

class ApplicationState: ObservableObject {
    @Published var apolloClient: ApolloClient? = nil
    @Published var teams: [Any] = []
}

@main
struct Import_to_LinearApp: App {
    var applicationState = ApplicationState()
    
    init() {
        applicationState.apolloClient.objectWillChange.sink { a in
            self.applicationState.apolloClient.fetch(query: GetTeamsQuery()) { response in
                switch response {
                    case .success(let result):
                        if result.errors == nil {
                            debugPrint(result.data)
                        }
                    case .failure(let error):
                      print(error)
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(applicationState)
        }
    }
}
