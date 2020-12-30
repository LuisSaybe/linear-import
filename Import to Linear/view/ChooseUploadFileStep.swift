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
            Text("Your selected .csv file accepts the following columns").font(.title2)
            VStack(alignment: .leading) {
                Text("- Title (Required)").font(.title2)
                Text("- Description (Optional)").font(.title2)
                Text("- Priority (Optional)").font(.title2)
                VStack(alignment: .leading) {
                    Text("0 - No Priority").font(.title2)
                    Text("1 - Urgent").font(.title2)
                    Text("2 - High").font(.title2)
                    Text("3 - Medium").font(.title2)
                    Text("4 - Low").font(.title2)
                }.padding(.leading, 15).padding(.top, 5)
            }.padding()
            HStack {
                Button(action: {
                    self.store.send(.updateTeamViewState(teamId: self.teamId, data: TeamViewState.getDefault()))
                }) {
                    Text("Back").font(.title2)
                }
                Button(action: self.onUploadClick) {
                    Text("Choose a .csv file").font(.title2)
                }
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}





