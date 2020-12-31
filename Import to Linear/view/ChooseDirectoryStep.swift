import SwiftUI

struct ChooseDirectoryStep: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    @State var folder: URL?
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }

    func startDownload() {
        if let folder = self.folder,
           let url = CSVHelper.createWritableCSVFile(url:folder) {
            let data = TeamViewState(
                step: .DownloadProgress,
                isDownloading: nil,
                downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                isUploading: nil,
                uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                downloadUrl: url,
                uploadUrl: nil
            )
            self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
        } else {
            let alert = NSAlert()
            alert.informativeText = "Sorry, we're not able to create a file in that folder, please try again."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Ok")
            alert.runModal()
        }
    }

    func onChooseFolder() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                self.folder = openPanel.url
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let folder = self.folder {
                Text("Files will be downloaded to \(folder.lastPathComponent)").font(.title2)
            } else {
                Text("Select a download folder to get started").font(.title2)
            }
            HStack {
                Button("Back", action: {
                    self.store.send(.updateTeamViewState(teamId: self.teamId, data: TeamViewState.getDefault()))
                })
                Button("Choose a folder", action: self.onChooseFolder)
                Button("Start download", action: self.startDownload).disabled(self.folder == nil)
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}
