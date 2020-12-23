import Apollo
import Combine

enum ApplicationView {
    case Root
    case Teams
}

enum ApplicationAction {
    case setApolloClient(data: ApolloClient?)
    case setTeams(data: [GetTeamsQuery.Data.Team.Node])
    case setFailedToLoadTeams(data: Bool)
    case setFailedToLogin(data: Bool)
    case setView(data: ApplicationView)
}

struct ApplicationState {
    var apolloClient: ApolloClient?
    var teams: [GetTeamsQuery.Data.Team.Node]
    var failedToLoadTeams: Bool
    var failedToLogin: Bool
    var currentView: ApplicationView
}

func applicationReducer(
    state: inout ApplicationState,
    action: ApplicationAction
) -> AnyPublisher<ApplicationAction, Never>? {
    switch action {
        case let .setApolloClient(client):
            state.apolloClient = client
        case let .setTeams(teams):
            state.teams = teams
        case let .setFailedToLoadTeams(data):
            state.failedToLoadTeams = data
        case let .setFailedToLogin(data):
            state.failedToLogin = data
        case let .setView(data):
            state.currentView = data
    }
    return nil
}
