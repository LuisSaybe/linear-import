import SwiftUI

struct ChooseDirectoryStep: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }
    
    func onDownloadClick() {
        let helper = CSVHelper(client: self.store.state.apolloClient!)

        helper.createWritableCSVFile { result in
            switch result {
                case.success(let url):
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
                case .failure:
                    print("can not use that file!")
                
            }
        }
    }

    var body: some View {
        VStack {
            Text("Select a download folder to get start").font(.title3)
            HStack {
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
                    Text("Back")
                }
                Button(action: self.onDownloadClick) {
                    Text("Choose a folder")
                }
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}




