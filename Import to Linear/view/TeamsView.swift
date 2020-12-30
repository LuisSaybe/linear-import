import SwiftUI

struct TeamsView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    func onAppear() {
        if let client = self.store.state.apolloClient {
            self.store.send(.setIsLoadingTeams(data: true))
            self.store.send(.setFailedToLoadTeams(data: false))

            client.fetch(query: GetTeamsQuery(first: 100)) { response in
                switch response {
                    case .success(let result):
                        if let data = result.data {
                            self.store.send(.setTeams(data: data.teams.nodes))
                        } else {
                            self.store.send(.setFailedToLoadTeams(data: true))
                        }
                    case .failure:
                        self.store.send(.setFailedToLoadTeams(data: true))
                }

                self.store.send(.setIsLoadingTeams(data: false))
            }
        }
    }

    var body: some View {
        if self.store.state.isLoadingTeams && self.store.state.teams.isEmpty {
            ProgressView()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .onAppear(perform: self.onAppear)
        } else if self.store.state.failedToLoadTeams {
            VStack(alignment: .leading) {
                Text("Sorry, we were not able to load your teams").foregroundColor(.red)
                Button(action: self.onAppear) {
                    Text("Reload teams")
                }
                Spacer()
            }
                .frame(minHeight: 0, maxHeight: .infinity)
                .padding()
        } else if self.store.state.teams.isEmpty {
            VStack(alignment: .leading) {
                Text("Sorry, it appears you don't have any teams.")
                Text("Try adding teams in your linear account and then restart the app.").padding(.top, 10)
                Link("Visit linear.app", destination: URL(string: "https://linear.app")!).font(.title3).padding(.top, 10)
                Spacer()
            }
                .frame(minHeight: 0, maxHeight: .infinity)
                .padding()
                .onAppear(perform: self.onAppear)
        } else {
            TeamsScrollView()
                .onAppear(perform: self.onAppear)
        }
    }
}
