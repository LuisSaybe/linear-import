import SwiftUI

struct ListTeam : Hashable {
    let node: GetTeamsQuery.Data.Team.Node
    let Id: String

    static func == (lhs: ListTeam, rhs: ListTeam) -> Bool {
        return lhs.Id == rhs.Id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(Id)
    }
}

struct TeamsView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    
    var body: some View {
        VStack {
            ForEach(self.store.state.teams.map { node in
                return ListTeam(
                    node: node,
                    Id: node.id
                )
            }, id: \.self) { _ in
                TeamView()
            }
        }.onAppear {
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
    }
}
