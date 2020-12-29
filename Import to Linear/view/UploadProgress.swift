import SwiftUI

struct UploadProgress: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }

    func getViewState() -> TeamViewState? {
        if let viewState = self.store.state.teamViewState[self.teamId] {
            return viewState
        }

        return nil
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
                uploadUrl: viewState.uploadUrl
            )
        }

        return nil
    }

    func onAppear() {
        if let teamId = self.store.state.currentSelectedTeamId,
           let viewState = self.getViewState(),
           let url = viewState.uploadUrl,
           let client = self.store.state.apolloClient {

            if viewState.isUploading == nil {
                let helper = CSVHelper(client: client)

                helper.uploadToLinearTeam(teamId: teamId, url: url, onUpdate: { uploadProgress in
                    if let data = self.getNextProgressState(data: uploadProgress, isUploading: true) {
                        self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
                    }
                }, completionHandler: { result in
                    switch result {
                        case.success(let information):
                            debugPrint(information)
                        case .failure(let error):
                            debugPrint(error)
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
        VStack(alignment: .leading) {
            if let viewState = self.getViewState() {
                Text("Uploaded \(viewState.uploadCompletionInformation.successCount) issue\(viewState.uploadCompletionInformation.successCount == 1 ? "" : "s")").font(.title2).padding()
                Text("Failed to upload \(viewState.uploadCompletionInformation.failureCount) issue\(viewState.uploadCompletionInformation.successCount == 1 ? "" : "s")").font(.title2).padding()

                if viewState.isUploading == nil || viewState.isUploading == true {
                    ProgressView().padding()
                } else {
                    Text("Job Complete").font(.title2).padding()
                    Button(action: {
                        self.store.send(.updateTeamViewState(teamId: self.teamId, data: TeamViewState(
                            step: .Start,
                            isDownloading: nil,
                            downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                            isUploading: nil,
                            uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                            downloadUrl: nil,
                            uploadUrl: nil
                        )))
                    }) {
                        Text("Restart")
                    }.padding()
                }
            } else {
                Text("Unable to determine currently selected team")
                Button(action: {
                    self.store.send(.setCurrentlySelectedTeamId(teamId: nil))
                }) {
                    Text("Restart")
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear(perform: self.onAppear)
    }
}
