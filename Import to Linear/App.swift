import SwiftUI
import Apollo
import Combine

let store = ApolloStore()
let provider = LegacyInterceptorProvider(store: store)
let requestChain = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://api.linear.app/graphql")!, additionalHeaders: [
    "authorization": "Bearer"
])
let client = ApolloClient(networkTransport: requestChain, store: store)

@main
struct Application: App {
    @Environment(\.colorScheme) var colorScheme
    let store = ApplicationStore<ApplicationState, ApplicationAction>(initialState: ApplicationState(
        apolloClient: client,
        currentView: .Dashboard,
        teams: [],
        teamViewState: [:],
        failedToLoadTeams: false,
        isLoadingTeams: false,
        failedToLogin: false
    ), reducer: applicationReducer)

    var body: some Scene {
        WindowGroup {
            Router()
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
                .environmentObject(self.store)
        }
    }
}
