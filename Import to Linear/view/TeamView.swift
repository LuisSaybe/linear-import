import SwiftUI

struct TeamView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    let teamId: String

    init(teamId: String) {
        self.teamId = teamId
    }

    func onDownloadClick() {
        let helper = CSVHelper(client: self.store.state.apolloClient!)

        self.store.send(.setTeamDownloadingIssues(teamId: self.teamId, downloading: true))

        helper.createWritableCSVFile { result in
            switch result {
                case.success(let url):
                    helper.writeTeamIdsToURL(url: url, teamId: self.teamId) { result in
                        switch result {
                            case.success(let completionInformation):
                                debugPrint(completionInformation)
                                self.store.send(.setTeamDownloadingIssues(teamId: self.teamId, downloading: false))
                            case .failure(let error):
                                print(error)
                                self.store.send(.setTeamDownloadingIssues(teamId: self.teamId, downloading: false))
                        }
                    }
                case .failure(let error):
                    print("error", error)
                    self.store.send(.setTeamDownloadingIssues(teamId: self.teamId, downloading: false))
                
            }
        }
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

            self.store.send(.setTeamUploadingIssues(teamId: self.teamId, uploading: true))
            let helper = CSVHelper(client: self.store.state.apolloClient!)
            self.store.send(.setTeamUploadingIssues(teamId: self.teamId, uploading: true))

            helper.uploadToLinearTeam(teamId: self.teamId, url: panel.url!, completionHandler: { result in
                switch result {
                    case.success(let information):
                        debugPrint(information)
                    case .failure(let error):
                        debugPrint(error)
                }

                self.store.send(.setTeamUploadingIssues(teamId: self.teamId, uploading: false))
            })
        }
    }

    var body: some View {
        let index = self.store.state.teams.firstIndex{$0.id == self.teamId}
        let team = self.store.state.teams[index ?? 0];

        return VStack {
            HStack {
                Text(team.name)
                    .padding()
                Spacer()
            }
            Divider()
            HStack {
                Button(action: self.onDownloadClick, label: {
                    Text("Download issues")
                })
                .disabled(self.store.state.teamIdDownloadingIssues.contains(self.teamId))
                Button(action: self.onUploadClick, label: {
                    Text("Upload issues")
                })
                .disabled(self.store.state.teamIdUploadingIssues.contains(self.teamId))
            }
            .frame(minHeight: 0, maxHeight: .infinity)
        }
    }
}


