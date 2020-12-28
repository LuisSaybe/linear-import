import Apollo
import Foundation
import Combine

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
    case setWorkflowStep(data: WorkflowStep)
    case setTeamDownloadingIssues(teamId: String, downloading: Bool)
    case setTeamUploadingIssues(teamId: String, uploading: Bool)
    case setCurrentlySelectedTeamId(teamId: String?)
    case setDownloadUrl(url: URL?)
    case setUploadCsvUrl(url: URL?)
}

struct ApplicationState {
    var apolloClient: ApolloClient?
    var currentView: ApplicationView
    var teams: [GetTeamsQuery.Data.Team.Node]
    
    var workflowStep: WorkflowStep
    var downloadUrl: URL?
    var uploadCsvUrl: URL?
    
    var failedToLoadTeams: Bool
    var isLoadingTeams: Bool
    
    var failedToLogin: Bool
    var teamIdDownloadingIssues: Set<String>
    var teamIdUploadingIssues: Set<String>
    var currentSelectedTeamId: String?
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
        case let .setIsLoadingTeams(data):
            state.isLoadingTeams = data
        case let .setView(data):
            state.currentView = data
        case let .setWorkflowStep(data):
            state.workflowStep = data
        case let .setDownloadUrl(data):
            state.downloadUrl = data
        case let .setUploadCsvUrl(data):
            state.uploadCsvUrl = data
        case let.setTeamDownloadingIssues(teamId, downloading):
            if downloading {
                state.teamIdDownloadingIssues.insert(teamId)
            } else {
                state.teamIdDownloadingIssues.remove(teamId)
            }
        case let .setTeamUploadingIssues(teamId, uploading):
            if uploading {
                state.teamIdUploadingIssues.insert(teamId)
            } else {
                state.teamIdUploadingIssues.remove(teamId)
            }
        case let .setCurrentlySelectedTeamId(teamId):
            state.currentSelectedTeamId = teamId
    }
    return nil
}

