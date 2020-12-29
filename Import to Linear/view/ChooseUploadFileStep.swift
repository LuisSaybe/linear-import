import SwiftUI

struct ChooseUploadFileStep: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }

    func onUploadClick() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["csv"]

        panel.begin { (result) -> Void in
            if result.rawValue != NSApplication.ModalResponse.OK.rawValue
            {
                return
            }

            let data = TeamViewState(
                step: .UploadProgress,
                isDownloading: nil,
                downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                isUploading: nil,
                uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                downloadUrl: nil,
                uploadUrl: panel.url
            )

            self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your selected .csv file accepts the following columns")
            VStack(alignment: .leading) {
                Text("- Title")
                Text("- Description")
            }.padding()
            HStack {
                Button(action: {
                    self.store.send(.updateTeamViewState(teamId: self.teamId, data: TeamViewState(
                        step: .Start,
                        isDownloading: false,
                        downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                        isUploading: false,
                        uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                        downloadUrl: nil,
                        uploadUrl: nil
                    )))
                }) {
                    Text("Back")
                }
                Button(action: self.onUploadClick) {
                    Text("Choose a .csv file")
                }
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}





