import Apollo
import Foundation
import Combine

struct CompletionInformation {
    var failureCount: Int
    var successCount: Int
}

struct TeamViewState {
    let step: WorkflowStep
    let isDownloading: Bool?
    let downloadCompletionInformation: CompletionInformation
    let isUploading: Bool?
    let uploadCompletionInformation: CompletionInformation
    let downloadUrl: URL?
    let uploadUrl: URL?
    let uploadRowErrors: [UploadRowError]

    static func getDefault() -> TeamViewState {
        return TeamViewState(
            step: .Start,
            isDownloading: false,
            downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
            isUploading: false,
            uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
            downloadUrl: nil,
            uploadUrl: nil,
            uploadRowErrors: []
        )
    }
}

enum ApplicationView {
    case Root
    case Dashboard
}

enum WorkflowStep {
    case Start

    case UploadStart
    case UploadProgress
    
    case DownloadStart
    case DownloadProgress
}

enum ApplicationAction {
    case setApolloClient(data: ApolloClient?)
    case setTeams(data: [GetTeamsQuery.Data.Team.Node])
    case setFailedToLoadTeams(data: Bool)
    case setFailedToLogin(data: Bool)
    case setIsLoadingTeams(data: Bool)
    case setView(data: ApplicationView)
    case setCurrentlySelectedTeamId(teamId: String?)
    case updateTeamViewState(teamId: String, data: TeamViewState)
    case reset
}

struct ApplicationState {
    var apolloClient: ApolloClient?
    var currentView: ApplicationView
    var teams: [GetTeamsQuery.Data.Team.Node]
    
    var teamViewState: [String : TeamViewState]

    var failedToLoadTeams: Bool
    var isLoadingTeams: Bool
    
    var failedToLogin: Bool
    var currentSelectedTeamId: String?
}

func applicationReducer(
    state: inout ApplicationState,
    action: ApplicationAction
) -> AnyPublisher<ApplicationAction, Never>? {
    switch action {
        case .reset:
            state.apolloClient = nil
            state.currentSelectedTeamId = nil
            state.teams = []
            state.teamViewState = [:]
            state.currentView = .Root
        case let .setApolloClient(client):
            state.apolloClient = client
        case let .setTeams(teams):
            state.teams = teams

            for team in teams {
                if state.teamViewState[team.id] == nil {
                    state.teamViewState[team.id] = TeamViewState(
                        step: .Start,
                        isDownloading: nil,
                        downloadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                        isUploading: nil,
                        uploadCompletionInformation: CompletionInformation(failureCount: 0, successCount: 0),
                        downloadUrl: nil,
                        uploadUrl: nil,
                        uploadRowErrors: []
                    )
                }
            }
        case let .setFailedToLoadTeams(data):
            state.failedToLoadTeams = data
        case let .setFailedToLogin(data):
            state.failedToLogin = data
        case let .setIsLoadingTeams(data):
            state.isLoadingTeams = data
        case let .setView(data):
            state.currentView = data
        case let .setCurrentlySelectedTeamId(teamId):
            state.currentSelectedTeamId = teamId
        case let .updateTeamViewState(teamId, data):            
            state.teamViewState[teamId] = data
    }
    return nil
}

