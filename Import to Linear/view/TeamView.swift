import SwiftUI

struct TeamView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    var body: some View {
        VStack {
            if let teamId = self.store.state.currentSelectedTeamId {
                let teamStateView = self.store.state.teamViewState[teamId]
                let index = self.store.state.teams.firstIndex{$0.id == teamId}
                let team = self.store.state.teams[index ?? 0]

                HStack {
                    Text(team.name)
                        .font(.title)
                    Spacer()
                    Button("Logout", action: {
                        self.store.send(.reset)
                    }).buttonStyle(PlainButtonStyle()).font(.title)
                }.padding()
                Divider()
                if teamStateView?.step == .UploadStart {
                    ChooseUploadFileStep(teamId: teamId)
                } else if teamStateView?.step == .DownloadStart {
                    ChooseDirectoryStep(teamId: teamId)
                } else if teamStateView?.step == .DownloadProgress {
                    DownloadProgress(teamId: teamId)
                } else if teamStateView?.step == .UploadProgress {
                    UploadProgress(teamId: teamId)
                } else if teamStateView?.step == .Start {
                    TeamWorkflowHome(teamId: teamId)
                } else {
                    Text("Can not determine current workflow step")
                }
            } else {
                Text("No team currently selected")
            }
        }
    }
}


