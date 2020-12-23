import SwiftUI
import Apollo
import Combine

@main
struct Import_to_LinearApp: App {
    let store = ApplicationStore<ApplicationState, ApplicationAction>(initialState: ApplicationState(
        apolloClient: nil,
        teams: [],
        failedToLoadTeams: false,
        failedToLogin: false,
        currentView: ApplicationView.Root
    ), reducer: applicationReducer)

    var body: some Scene {
        WindowGroup {
            Router()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(self.store)
        }
    }
}
