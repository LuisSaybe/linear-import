import SwiftUI

struct UploadProgress: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    @State var isUploading: Bool = true
    @State var uploadProgress: CompletionInformation = CompletionInformation(
        failureCount: 0,
        successCount: 0
    )

    func onAppear() {
        if let teamId = self.store.state.currentSelectedTeamId {
            if let url = self.store.state.uploadCsvUrl {
                let helper = CSVHelper(client: self.store.state.apolloClient!)

                helper.uploadToLinearTeam(teamId: teamId, url: url, onUpdate: { uploadProgress in
                    self.uploadProgress = uploadProgress
                }, completionHandler: { result in
                    switch result {
                        case.success(let information):
                            debugPrint(information)
                        case .failure(let error):
                            debugPrint(error)
                    }

                    self.isUploading = false
                })
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Uploaded \(self.uploadProgress.successCount) issue\(self.uploadProgress.successCount == 1 ? "" : "s")").font(.title2).padding()
            Text("Failed to upload \(self.uploadProgress.failureCount) issue\(self.uploadProgress.successCount == 1 ? "" : "s")").font(.title2).padding()
            
            if self.isUploading {
                ProgressView().padding()
            } else {
                Text("Succesfully uploaded issues").font(.title2).padding()
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear(perform: self.onAppear)
    }
}
