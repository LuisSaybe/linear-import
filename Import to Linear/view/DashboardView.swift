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
            if store.state.currentSelectedTeamId == nil {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.store.send(.setApolloClient(data: nil))
                            self.store.send(.setView(data: .Root))
                        }) {
                            Text("Logout").font(.title)
                        }.buttonStyle(PlainButtonStyle())
                    }.padding()
                    Divider()
                    Text("Select a team to start")
                        .font(.title2)
                        .frame(minWidth: 1, maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                TeamView()
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

