import AuthenticationServices

class SignInViewModel: NSObject, ASWebAuthenticationPresentationContextProviding {
    let clientId: String
    let redirectScheme: String
    let redirectUri: String
    let completionHandler: ASWebAuthenticationSession.CompletionHandler

    init(clientId: String, redirectScheme: String, redirectUri: String, completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler) {
        self.clientId = clientId
        self.redirectScheme = redirectScheme
        self.redirectUri = redirectUri
        self.completionHandler = completionHandler
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }

    func attemptSignIn() {
        let authURL = URL(string: "https://linear.app/oauth/authorize?client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUri)&scope=read,write")!
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: redirectScheme, completionHandler: self.completionHandler)
        session.prefersEphemeralWebBrowserSession = true
        session.presentationContextProvider = self
        session.start()
    }
}
