import SwiftUI
import Foundation

struct ChooseUploadFileStep: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    @State var fileToUpload: URL?
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }

    func showDownloadFailure() {
        let alert = NSAlert()
        alert.informativeText = "Sorry we are not able to download that example file, please try again."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
    
    func showDownloadSuccess(location: String) {
        let alert = NSAlert()
        alert.informativeText = "Your example file has been downloaded to \(location)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }

    func onDownloadExampleCSVClick() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let asset = NSDataAsset(name: "example-upload"),
                   let downloadDirectory = openPanel.url,
                   let filePath = URL(string: downloadDirectory.absoluteString)?.appendingPathComponent("linear-example-upload", isDirectory: false).appendingPathExtension("csv") {
                    let created = FileManager.default.createFile(atPath: filePath.path, contents: asset.data)
                    
                    if created {
                        self.showDownloadSuccess(location: downloadDirectory.lastPathComponent)
                    } else {
                        self.showDownloadFailure()
                    }
                } else {
                    self.showDownloadFailure()
                }
            }
        }
    }
    
    func onUploadStart() {
        let data = TeamViewState(
            step: .UploadProgress,
            isDownloading: nil,
            downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
            isUploading: nil,
            uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
            downloadUrl: nil,
            uploadUrl: self.fileToUpload
        )

        self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
    }
    
    func onUploadClick() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["csv"]

        panel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                self.fileToUpload = panel.url
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your selected .csv file accepts the following columns").font(.title2)
            VStack(alignment: .leading, spacing: 5) {
                Text("- Title (Required)").font(.title2)
                Text("- Description (Optional)").font(.title2)
                Text("- Priority (Optional)").font(.title2)
                VStack(alignment: .leading) {
                    Text("0 - No Priority").font(.title2)
                    Text("1 - Urgent").font(.title2)
                    Text("2 - High").font(.title2)
                    Text("3 - Medium").font(.title2)
                    Text("4 - Low").font(.title2)
                }.padding(.leading, 15)
                Text("- Assignee (Optional)").font(.title2)
                VStack(alignment: .leading) {
                    Text("The Linear UUID of the assignee").font(.title2)
                }.padding(.leading, 15)
                Text("- State (Optional)").font(.title2)
                VStack(alignment: .leading) {
                    Text("The Linear UUID of the issue's state. This is the status in field in the user interface").font(.title2)
                }.padding(.leading, 15)
                Text("- Labels (Optional)").font(.title2)
                VStack(alignment: .leading) {
                    Text("A comma delimited string of Linear UUID issue labels").font(.title2)
                }.padding(.leading, 15)
            }
            if let file = self.fileToUpload {
                Text("Data will be uploaded from \(file.lastPathComponent)").font(.title2)
            }
            HStack {
                Button("Back", action: {
                    self.store.send(.updateTeamViewState(teamId: self.teamId, data: TeamViewState.getDefault()))
                })
                Button("Download example", action: self.onDownloadExampleCSVClick)
                Button("Choose a .csv file", action: self.onUploadClick)
                Button("Start Upload", action: self.onUploadStart).disabled(self.fileToUpload == nil)
            }
        }.frame(maxHeight: .infinity)
    }
}
