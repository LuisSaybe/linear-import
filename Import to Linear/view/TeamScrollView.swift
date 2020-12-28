import SwiftUI

struct TeamsScrollView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    
    var body: some View {
        ScrollView {
            ForEach(self.store.state.teams, id: \.id) { team in
                Button(action: {
                    self.store.send(.setWorkflowStep(data: .Start))
                    self.store.send(.setCurrentlySelectedTeamId(teamId: team.id))
                }) {
                    VStack(alignment: .leading) {
                        Text(team.name)
                            .font(.title2)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if let description = team.description {
                            Text(description).font(.subheadline).lineLimit(2)
                        } else {
                            Text("No description").italic().font(.subheadline).lineLimit(2)
                        }
                    }
                    .contentShape(Rectangle())
                    .padding()
                    
                }
                .buttonStyle(PlainButtonStyle())
                .background(self.store.state.currentSelectedTeamId == team.id ? Color(NSColor(named: NSColor.Name("TeamSelectedColor"))!) : Color.clear)
            }
        }
        .frame(minHeight: 0, maxHeight: .infinity)
    }
}
