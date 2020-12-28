import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    var body: some View {
        return HStack {
            VStack(alignment: .leading) {
                Text("My Linear Teams")
                    .padding()
                    .font(.title)
                Divider()
                TeamsView()
            }
            .frame(minWidth: 0, maxWidth: 300)
            Divider()
            if let selectedTeamId = store.state.currentSelectedTeamId {
                TeamView(teamId: selectedTeamId)
                    .frame(minWidth: 0, maxWidth: .infinity)
            } else {
                Text("Select a team to start")
                    .font(.title2)
                    .frame(minWidth: 1, maxWidth: .infinity)
            }
        }
    }
}

