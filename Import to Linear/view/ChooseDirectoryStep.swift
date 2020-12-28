import SwiftUI

struct ChooseDirectoryStep: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    func onDownloadClick() {
        let helper = CSVHelper(client: self.store.state.apolloClient!)

        helper.createWritableCSVFile { result in
            switch result {
                case.success(let url):
                    self.store.send(.setDownloadUrl(url: url))
                    self.store.send(.setWorkflowStep(data: .DownloadProgress))
                case .failure:
                    print("can not use that file!")
                
            }
        }
    }

    var body: some View {
        VStack {
            Text("Select a download folder to get start").font(.title3)
            Button(action: self.onDownloadClick) {
                Text("Choose a folder")
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}




