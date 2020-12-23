import SwiftUI
import CSV
import Alamofire
import Apollo

struct ContentView: View {
    @EnvironmentObject var applicationState: ApplicationState
    let teamId = "c4e41f33-8e10-43d5-85ef-03ecadb94d06"
    let clientId = ""
    let redirectScheme = "com.luissaybe.linear-tools"
    let redirectUri = "com.luissaybe.linear-tools://oauth-redirect"
    let clientSecret = ""

    var body: some View {
        VStack {
            if let client = applicationState.apolloClient {
                TeamsView()
                Button(action: {
                    CsvUtility(client:client).writeTeamIssuesToDownloads(teamId: self.teamId)
                }, label: {
                    Text("Download as CSV")
                })
                Button(action: {
                    let dialog = NSOpenPanel()
                    dialog.title                   = "Choose a file"
                    dialog.showsResizeIndicator    = true
                    dialog.showsHiddenFiles        = false
                    dialog.allowsMultipleSelection = false
                    dialog.canChooseDirectories = false
                    dialog.allowedFileTypes = ["csv"]

                    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
                        let csvUtility = CsvUtility(client: client)
                        let result = csvUtility.uploadToLinearTeam(teamId: self.teamId, file: dialog.urls[0])

                        debugPrint(result)
                    }
                }, label: {
                    Text("Choose file")
                }).padding()
            }
            if self.applicationState.apolloClient == nil {
                Button(action: {
                    SignInViewModel(clientId: self.clientId, redirectScheme: self.redirectScheme, redirectUri: self.redirectUri, completionHandler: { callbackURL, error in
                        if error == nil {
                            let queryItems = URLComponents(string: callbackURL!.absoluteString)?.queryItems
                            let code = queryItems?.filter({ $0.name == "code" }).first?.value

                            AF.request("https://api.linear.app/oauth/token", method: .post, parameters: [
                                "grant_type": "authorization_code",
                                "redirect_uri": self.redirectUri,
                                "code": code!,
                                "client_secret": self.clientSecret,
                                "client_id": self.clientId
                            ], headers: [
                                "content-type":"application/x-www-form-urlencoded"
                            ]).responseJSON { response in
                                switch response.result {
                                    case .success(let JSON):
                                        let response = JSON as! NSDictionary
                                        let accessToken = response.object(forKey: "access_token")!
                                        let store = ApolloStore(cache: InMemoryNormalizedCache())
                                        let provider = LegacyInterceptorProvider(store: store)
                                        let requestChain = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://api.linear.app/graphql")!, additionalHeaders: [
                                            "authorization": "Bearer \(accessToken)"
                                        ])
                                        self.applicationState.apolloClient = ApolloClient(networkTransport: requestChain, store: store)
                                    case .failure(let error):
                                        print("Request failed with error: \(error)")
                                }
                            }
                        }
                    }).attemptSignIn()
                }, label: {
                    Text("Login to your Linear Account")
                }).padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
