import SwiftUI

struct TeamView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }

    var body: some View {
        let index = self.store.state.teams.firstIndex{$0.id == self.teamId}
        let team = self.store.state.teams[index ?? 0]

        return VStack {
            HStack {
                Text(team.name)
                    .padding()
                    .font(.title)
                Spacer()
            }
            Divider()
            if self.store.state.workflowStep == .UploadStart {
                ChooseUploadFileStep()
            } else if self.store.state.workflowStep == .DownloadStart {
                ChooseDirectoryStep()
            } else if self.store.state.workflowStep == .DownloadProgress {
                DownloadProgress()
            } else if self.store.state.workflowStep == .UploadProgress {
                UploadProgress()
            } else {
                TeamWorkflowHome()
            }
        }
    }
}


