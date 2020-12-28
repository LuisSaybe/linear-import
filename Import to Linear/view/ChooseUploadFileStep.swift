import SwiftUI

struct ChooseUploadFileStep: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    func onUploadClick() {
        if let teamId = self.store.state.currentSelectedTeamId {
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

                self.store.send(.setUploadCsvUrl(url: panel.url!))
                self.store.send(.setWorkflowStep(data: .UploadProgress))
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your selected .csv file accepts the following columns")
            VStack(alignment: .leading) {
                Text("- Title")
                Text("- Description")
            }.padding()
            Button(action: self.onUploadClick) {
                Text("Choose a .csv file")
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}





