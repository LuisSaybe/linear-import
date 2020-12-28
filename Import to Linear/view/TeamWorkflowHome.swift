import SwiftUI

struct TeamWorkflowHome: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>

    var body: some View {
        VStack {
            Text("Please select a workflow").font(.title3)
            HStack {
                Button(action: {
                    self.store.send(.setWorkflowStep(data: .UploadStart))
                }) {
                    Text("I want to upload issues")
                }
                Button(action: {
                    self.store.send(.setWorkflowStep(data: .DownloadStart))
                }) {
                    Text("I want to download my issues")
                }
            }.padding(.top, 10)
        }.frame(maxHeight: .infinity)
    }
}



