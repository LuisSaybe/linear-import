import SwiftUI

struct TeamsView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    func onAppear() {
        if let client = self.store.state.apolloClient {
            client.fetch(query: GetTeamsQuery()) { response in
                switch response {
                    case .success(let result):
                        if let data = result.data {
                            self.store.send(.setFailedToLoadTeams(data: false))
                            self.store.send(.setTeams(data: data.teams.nodes))
                        }
                    case .failure:
                        self.store.send(.setFailedToLoadTeams(data: true))
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(self.store.state.teams, id: \.id) { team in
                Button(action: {
                    self.store.send(.setCurrentlySelectedTeamId(teamId: team.id))
                }) {
                    VStack(alignment: .leading) {
                        Text(team.name).font(.title3).lineLimit(1).padding().frame(maxWidth:.infinity, alignment: .leading)
                        if let description = team.description {
                            Text(description).font(.subheadline).lineLimit(2).padding()
                        }
                    }.background(Color.red)
                }
                .buttonStyle(PlainButtonStyle())
                .background(self.store.state.currentSelectedTeamId == team.id ? Color.blue : Color.clear)
            }
        }
        .onAppear(perform: self.onAppear)
    }
}
