import SwiftUI
import CSV

struct UploadProgress: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let teamId: String
    @State var uploadError: UploadErrors? = nil

    init(teamId: String) {
        self.teamId = teamId
    }

    func getViewState() -> TeamViewState? {
        if let viewState = self.store.state.teamViewState[self.teamId] {
            return viewState
        }

        return nil
    }

    func onDownloadErrors() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { (result) -> Void in
            let onUnableToDownload = {
                let alert = NSAlert()
                alert.informativeText = "Sorry, we were not able to download errors from this upload, please choose a different directory."
                alert.alertStyle = .warning
                alert.addButton(withTitle: "Ok")
                alert.runModal()
            }
            
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let directory = openPanel.url,
                   let errorUrl = CSVHelper.createWritableCSVFile(url: directory, prefix: "errors-linear-upload") {
                    var csv: CSVWriter? = nil
                    
                    do  {
                        if let stream = OutputStream(url: errorUrl, append: true) {
                            csv = try CSVWriter(stream: stream)
                        }
                    } catch {
                        return
                    }

                    if let writer = csv,
                       let viewState = self.getViewState() {
                        try? writer.write(row: ["row", "title", "errors"])

                        for error in viewState.uploadRowErrors {
                            try? writer.write(row: [String(error.rowIndex), error.title, error.errors.map { $0.localizedDescription }.joined(separator: ",")])
                        }
                    } else {
                        onUnableToDownload()
                    }
                } else {
                    onUnableToDownload()
                }
            }
        }
    }
    
    func appendUploadRowError(error: UploadRowError) {
        if let viewState = self.getViewState() {
            let data = TeamViewState(
                step: viewState.step,
                isDownloading: viewState.isDownloading,
                downloadCompletionInformation: viewState.downloadCompletionInformation,
                isUploading: viewState.isUploading,
                uploadCompletionInformation: viewState.uploadCompletionInformation,
                downloadUrl: viewState.downloadUrl,
                uploadUrl: viewState.uploadUrl,
                uploadRowErrors: viewState.uploadRowErrors + [error]
            )

            self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
        }
    }
    
    func getNextProgressState(data: CompletionInformation, isUploading: Bool) -> TeamViewState? {
        if let viewState = self.getViewState() {
            return TeamViewState(
                step: viewState.step,
                isDownloading: viewState.isDownloading,
                downloadCompletionInformation: viewState.downloadCompletionInformation,
                isUploading: isUploading,
                uploadCompletionInformation: data,
                downloadUrl: viewState.downloadUrl,
                uploadUrl: viewState.uploadUrl,
                uploadRowErrors: viewState.uploadRowErrors
            )
        }

        return nil
    }

    func onAppear() {
        if let viewState = self.getViewState(),
           let url = viewState.uploadUrl,
           let client = self.store.state.apolloClient {

            if viewState.isUploading == nil {
                let helper = CSVHelper(client: client)

                helper.uploadToLinearTeam(teamId: self.teamId, url: url, onError: { uploadError in
                    self.appendUploadRowError(error: uploadError)
                }, onUpdate: { uploadProgress in
                    if let data = self.getNextProgressState(data: uploadProgress, isUploading: true) {
                        self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
                    }
                }, completionHandler: { result in
                    switch result {
                        case.success(let information):
                            debugPrint(information)
                        case .failure(let error):
                            self.uploadError = error
                    }

                    if let viewState = self.getViewState(),
                       let data = self.getNextProgressState(data: viewState.uploadCompletionInformation, isUploading: false) {
                        self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
                    }
                })
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let error = self.uploadError {
                switch error {
                    case .canNotCreateCSVReader:
                        Text("Sorry, we are not able to open your selected file, please try another file.").font(.title3)
                    case .missingUniqueTitleColumn:
                        Text("Sorry, the file you chose does not have a unique Title column, please try another file.").font(.title3)
                }
                Button("Return to start menu", action: {
                    self.store.send(.updateTeamViewState(teamId: self.teamId, data: TeamViewState.getDefault()))
                }).font(.title3)
            } else if let viewState = self.getViewState() {
                Text("Uploaded \(viewState.uploadCompletionInformation.successCount) issue\(viewState.uploadCompletionInformation.successCount == 1 ? "" : "s")").font(.title3)
                Text("Failed to upload \(viewState.uploadCompletionInformation.failureCount) issue\(viewState.uploadCompletionInformation.failureCount == 1 ? "" : "s")").font(.title3)

                if viewState.isUploading == nil || viewState.isUploading == true {
                    ProgressView().padding()
                } else {
                    Text("Job Complete").font(.title3)
                    HStack {
                        if !viewState.uploadRowErrors.isEmpty {
                            Button("Download errors", action: self.onDownloadErrors)
                        }
                        Button("Return to start menu", action: {
                            self.store.send(.updateTeamViewState(teamId: self.teamId, data: TeamViewState.getDefault()))
                        })
                    }
                }
            } else {
                Text("Unable to determine currently selected team")
                Button("Return to start menu", action: {
                    self.store.send(.setCurrentlySelectedTeamId(teamId: nil))
                })
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear(perform: self.onAppear)
    }
}
