import SwiftUI
import Apollo
import Combine

@main
struct Application: App {
    @Environment(\.colorScheme) var colorScheme
    let store = ApplicationStore<ApplicationState, ApplicationAction>(initialState: ApplicationState(
        apolloClient: nil,
        currentView: .Root,
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
