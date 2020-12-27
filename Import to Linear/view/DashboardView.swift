import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    var body: some View {
        return HStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("My Linear Teams")
                        .padding()
                    Divider()
                    TeamsView()
                }
            }
            .frame(minWidth: 0, maxWidth: 300)
            Divider()
            if let selectedTeamId = store.state.currentSelectedTeamId {
                TeamView(teamId: selectedTeamId)
                    .frame(minWidth: 0, maxWidth: .infinity)
            } else {
                Text("Select a team")
                    .frame(minWidth: 1, maxWidth: .infinity)
            }
        }
    }
}

