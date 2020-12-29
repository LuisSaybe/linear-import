import SwiftUI

struct DownloadProgress: View {
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

    func getNextProgressState(data: CompletionInformation, isDownloading: Bool) -> TeamViewState? {
        if let viewState = self.getViewState() {
            return TeamViewState(
                step: viewState.step,
                isDownloading: isDownloading,
                downloadCompletionInformation: data,
                isUploading: viewState.isUploading,
                uploadCompletionInformation: viewState.uploadCompletionInformation,
                downloadUrl: viewState.downloadUrl,
                uploadUrl: viewState.uploadUrl
            )
        }

        return nil
    }

    func onAppear() {
        if let viewState = self.getViewState(),
           let url = viewState.downloadUrl,
           let client = self.store.state.apolloClient {
            let helper = CSVHelper(client: client)

            if viewState.isDownloading == nil {
                helper.writeTeamIssuesToURL(url: url, teamId: teamId, onUpdate: { data in
                    if let nextViewState = self.getNextProgressState(data: data, isDownloading: true) {
                        self.store.send(.updateTeamViewState(teamId: self.teamId, data: nextViewState))
                    }
                }) { result in
                    switch result {
                        case.success(let completionInformation):
                            debugPrint(completionInformation)
                        case .failure(let error):
                            print(error)
                    }

                    if let currentViewState = self.getViewState(),
                       let data = self.getNextProgressState(data: currentViewState.downloadCompletionInformation, isDownloading: false) {
                        self.store.send(.updateTeamViewState(teamId: self.teamId, data: data))
                    }
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let viewState = self.getViewState() {
                Text("Downloaded \(viewState.downloadCompletionInformation.successCount) issue\(viewState.downloadCompletionInformation.successCount == 1 ? "" : "s")").font(.title2).padding()
                Text("Failed to download \(viewState.downloadCompletionInformation.failureCount) issue\(viewState.downloadCompletionInformation.successCount == 1 ? "" : "s")").font(.title2).padding()

                if viewState.isDownloading == nil || viewState.isDownloading == true {
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
                Text("Unable to determine currentl view state")
                Button(action: {
                    self.store.send(.setCurrentlySelectedTeamId(teamId: nil))
                }) {
                    Text("Restart")
                }
            }
        }.frame(maxHeight: .infinity)
        .onAppear(perform: self.onAppear)
    }
}






