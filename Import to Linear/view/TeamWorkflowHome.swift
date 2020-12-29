import SwiftUI

struct TeamWorkflowHome: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }
    
    func getNextTeamViewData(step: WorkflowStep) -> TeamViewState {
        return TeamViewState(
            step: step,
            isDownloading: false,
            downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
            isUploading: false,
            uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
            downloadUrl: nil,
            uploadUrl: nil
        )
    }
    
    var body: some View {
        VStack {
            Text("What would you like to do?").font(.title3)
            HStack {
                Button(action: {
                    self.store.send(.updateTeamViewState(teamId: self.teamId, data: self.getNextTeamViewData(step: .UploadStart)))
                }) {
                    Text("I want to upload issues")
                }
                Button(action: {
                    self.store.send(.updateTeamViewState(teamId: self.teamId, data: self.getNextTeamViewData(step: .DownloadStart)))
                }) {
                    Text("I want to download my issues")
                }
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}



