import SwiftUI

struct DownloadProgress: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    @State private var isDownloading: Bool = true
    @State var uploadProgress: CompletionInformation = CompletionInformation(
        failureCount: 0,
        successCount: 0
    )

    func onAppear() {
        if let teamId = self.store.state.currentSelectedTeamId {
            if let url = self.store.state.downloadUrl {
                let helper = CSVHelper(client: self.store.state.apolloClient!)

                helper.writeTeamIssuesToURL(url: url, teamId: teamId, onUpdate: { uploadProgress in
                    self.uploadProgress = uploadProgress
                }) { result in
                    switch result {
                        case.success(let completionInformation):
                            debugPrint(completionInformation)
                        case .failure(let error):
                            print(error)
                    }
                    
                    self.isDownloading = false
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Downloaded \(self.uploadProgress.successCount) issue\(self.uploadProgress.successCount == 1 ? "" : "s")").font(.title2).padding()
            Text("Failed to download \(self.uploadProgress.failureCount) issue\(self.uploadProgress.successCount == 1 ? "" : "s")").font(.title2).padding()

            if self.isDownloading {
                ProgressView().padding()
            } else {
                Text("Succesfully downloaded issues").font(.title2).padding()
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear(perform: self.onAppear)
    }
}






