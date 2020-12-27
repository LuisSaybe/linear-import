import SwiftUI
import Apollo
import Combine

let store = ApolloStore(cache: InMemoryNormalizedCache())
let provider = LegacyInterceptorProvider(store: store)
let requestChain = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://api.linear.app/graphql")!, additionalHeaders: [
    "authorization": "Bearer b233c6aefcf4c1e3a68a95aea05b31e829e6a764869a759a89463b21244d867f"
])
let client = ApolloClient(networkTransport: requestChain, store: store)

@main
struct Application: App {
    let store = ApplicationStore<ApplicationState, ApplicationAction>(initialState: ApplicationState(
        apolloClient: client,
        currentView: ApplicationView.Dashboard,
        teams: [],
        failedToLoadTeams: false,
        failedToLogin: false,
        teamIdDownloadingIssues: [],
        teamIdUploadingIssues: []
    ), reducer: applicationReducer)

    var body: some Scene {
        WindowGroup {
            Router()
                .frame(minWidth: 600, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
                .environmentObject(self.store)
        }
    }
}
