import SwiftUI
import CSV
import Alamofire
import Apollo

struct LoginView: View {
    @EnvironmentObject var store: ApplicationStore<ApplicationState, ApplicationAction>
    @State var loginButtonDisabled: Bool = false
    let clientId = "41555b797aea67b9144f1fe11c2469e2"
    let redirectScheme = "com.luissaybe.linear-tools"
    let redirectUri = "com.luissaybe.linear-tools://oauth-redirect"
    let clientSecret = ""

    func showUnableToSignIn() {
        let alert = NSAlert()
        alert.informativeText = "Sorry, we were not able to retrieve an access token from your account. Please try again."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
    
    func onSignInComplete(callbackURL: URL?, error: Error?) -> Void {
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
                        debugPrint(response)
                        if let accessToken = response.object(forKey: "access_token") {
                            let store = ApolloStore(cache: InMemoryNormalizedCache())
                            let provider = LegacyInterceptorProvider(store: store)
                            let requestChain = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://api.linear.app/graphql")!, additionalHeaders: [
                                "authorization": "Bearer \(accessToken)"
                            ])
                            self.store.send(.setApolloClient(data: ApolloClient(networkTransport: requestChain, store: store)))
                            self.store.send(.setView(data: ApplicationView.Dashboard))
                        } else {
                            self.showUnableToSignIn()
                        }
                    case .failure:
                        self.showUnableToSignIn()
                }
            }
        }

        self.loginButtonDisabled = false
    }

    func onLoginClick() {
        self.loginButtonDisabled = true

        SignInViewModel(clientId: self.clientId, redirectScheme: self.redirectScheme, redirectUri: self.redirectUri, completionHandler: self.onSignInComplete).attemptSignIn()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Linear Tools").font(.title)
            HStack {
                Text("Linear Tools is an").font(.title2)
                Link("open source", destination: URL(string: "https://github.com/LuisSaybe/linear-import")!).font(.title2)
                Text("app that helps you import and export your linear issues from and to .csv files.").font(.title2)
            }
            Text("Log into your linear account to get started.").font(.title2)
            Button(action: self.onLoginClick, label: {
                Text("Login")
            })
            .disabled(self.loginButtonDisabled)
        }
    }
}
