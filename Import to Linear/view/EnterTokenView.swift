import SwiftUI
import CSV
import Alamofire
import Apollo

struct EnterTokenView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    @State var loginButtonDisabled: Bool = false
    @State private var key: String = ""
    
    func onInvalidClient() {
        let alert = NSAlert()
        alert.informativeText = "Sorry, the token you have entered is not valid. Please enter another token."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
    
    func onStartClick() {
        self.loginButtonDisabled = true

        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let provider = LegacyInterceptorProvider(store: store)
        let requestChain = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://api.linear.app/graphql")!, additionalHeaders: [
            "authorization": "\(self.key)"
        ])
        let client = ApolloClient(networkTransport: requestChain, store: store)

        client.fetch(query: GetTeamsQuery(first: 1)) { response in
            switch response {
                case .success(let result):
                    if result.data == nil {
                        self.onInvalidClient()
                        self.loginButtonDisabled = false
                    } else {
                        self.store.send(.setApolloClient(data: client))
                        self.store.send(.setView(data: ApplicationView.Dashboard))
                        self.loginButtonDisabled = false
                    }
                case .failure:
                    self.onInvalidClient()
                    self.loginButtonDisabled = false
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Saturn").font(.title)
            HStack {
                Text("Saturn is an").font(.title2)
                Link("open source", destination: URL(string: "https://github.com/luissaybe/saturn")!).font(.title2)
                Text("app that helps you import and export your").font(.title2)
                Link("Linear", destination: URL(string: "https://linear.app")!).font(.title2)
                Text("issues from and to .csv files.").font(.title2)
            }
            Text("Enter your Personal API Key from Linear -> Settings -> API to get started.").font(.title2)
            HStack(spacing: 10) {
                TextField("Enter your token...", text: self.$key)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 340)
                Button("Start", action: self.onStartClick)
                    .disabled(self.loginButtonDisabled)
            }
        }
    }
}

