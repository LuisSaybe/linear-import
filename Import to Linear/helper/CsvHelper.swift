import CSV
import Foundation
import Apollo
import AuthenticationServices

enum CreateCSVError : Error {
    case unableToCreateFile
    case userDecline
}

enum GetIssuesError : Error {
    case unableToFetchIssues
}

enum WriteIssuesError : Error {
    case unableToCreateStream
    case unableToCreateWriter
    case unableToWriteHeader
    case unableToFetchIssues
}

enum UploadErrors : Error {
    case canNotCreateCSVReader
    case missingUniqueTitleColumn
}

class CSVHelper {
    let client: ApolloClient

    init(client: ApolloClient) {
        self.client = client
    }

    func getAllTeamIssues(teamId: String, after: String? = nil, issueHandler: @escaping (GetTeamIssuesQuery.Data.Team.Issue.Node) -> Void, completionHandler: @escaping (Result<Any, Error>) -> Void) {
        self.client.fetch(query: GetTeamIssuesQuery(teamId: teamId, first: 100, after: after)) { response in
            switch response {
                case .success(let result):
                    if let data = result.data {
                        if data.team.issues.nodes.isEmpty {
                            completionHandler(.success(""))
                        } else {
                            for issue in data.team.issues.nodes {
                                issueHandler(issue)
                            }

                            self.getAllTeamIssues(teamId: teamId, after: data.team.issues.nodes.last!.id, issueHandler: issueHandler, completionHandler: completionHandler)
                        }
                    } else if let errors = result.errors {
                        completionHandler(.failure(errors[0]))
                    } else {
                        completionHandler(.failure(GetIssuesError.unableToFetchIssues))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
    
    func writeTeamIssuesToURL(url: URL, teamId: String, onUpdate: @escaping (CompletionInformation) -> Void, completionHandler: @escaping (Result<CompletionInformation, WriteIssuesError>) -> Void) {
        guard let stream = OutputStream(url: url, append: true) else {
            completionHandler(.failure(.unableToCreateStream))
            return
        }

        let csv: CSVWriter

        do  {
            csv = try CSVWriter(stream: stream)
        } catch {
            completionHandler(.failure(.unableToCreateWriter))
            return
        }

        do {
            try csv.write(row: ["id", "identifier", "title", "description", "priority", "estimate", "state", "labels", "assignee", "assigneeName"])
        } catch {
            completionHandler(.failure(.unableToWriteHeader))
            return
        }

        var failureCount = 0
        var successCount = 0

        getAllTeamIssues(teamId: teamId, issueHandler: { issue in
            let estimateColumn: String
            let priorityColumn = String(format: "%.0f", issue.priority)
            let labels = issue.labels.nodes.map { $0.id }.joined(separator: ",")
            
            if let estimate: Double = issue.estimate {
                estimateColumn = String(format: "%.1f", estimate)
            } else {
                estimateColumn = ""
            }

            do {
                try csv.write(row: [issue.id, issue.identifier, issue.title, issue.description ?? "", priorityColumn, estimateColumn, issue.state.id, labels, issue.assignee?.id ?? "", issue.assignee?.name ?? ""])
                successCount += 1
            } catch {
                failureCount += 1
            }
            
            onUpdate(CompletionInformation(
                failureCount: failureCount,
                successCount: successCount
            ))
        }, completionHandler: { result in
            switch result {
                case .success:
                    csv.stream.close()
                    completionHandler(.success(CompletionInformation(
                        failureCount: failureCount,
                        successCount: successCount
                    )))
                case .failure:
                    csv.stream.close()
            }
        })
    }
    
    static func createWritableCSVFile(url: URL) -> URL? {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let fileName = dateformat.string(from: Date())
        let filePath = URL(string: url.absoluteString)!.appendingPathComponent("linear-issues-\(fileName)", isDirectory: false).appendingPathExtension("csv")
        let created = FileManager.default.createFile(atPath: filePath.path, contents: "".data(using: .utf8))
        return created ? filePath : nil
    }

    func getRowsHeaderCellsWithSimilarValue(reader: CSVReader, target: String) -> [String] {
        var result: [String] = []

        if let headerRow = reader.headerRow {
            for title in headerRow {
                if title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == target.lowercased() {
                    result.append(title)
                }
            }
        }
        
        return result;
    }

    func getValue(row: CSVReader, header: String) -> String? {
        if let header = self.getRowsHeaderCellsWithSimilarValue(reader: row, target: header).first {
            return row[header]
        }
        
        return nil
    }

    func isValidRow(row: CSVReader) -> Bool {
        let title = getValue(row: row, header: "title")
        
        if let value = getValue(row: row, header: "priority") {
            return self.isValidPriority(value: value)
        }

        if title == nil || title == "" {
            return false
        }
        
        return true
    }

    func isValidPriority(value: String?) -> Bool {
        if let text = value, text.count > 0 {
            if let priorityNumber = Int(text) {
                return priorityNumber > -1 && priorityNumber < 5
            }

            return false
        }
        
        return true
    }

    func getLabelIds(row: CSVReader) -> [String] {
        if let labelIds = getValue(row: row, header: "labels") {
            return labelIds.components(separatedBy: ",")
        }

        return []
    }

    func uploadToLinearTeam(teamId : String, url: URL, onUpdate: @escaping (CompletionInformation) -> Void, completionHandler: @escaping (Result<CompletionInformation, UploadErrors>) -> Void) {
        let stream = InputStream(url: url)!
        let reader: CSVReader

        do {
            reader = try CSVReader(stream: stream, hasHeaderRow: true)
        } catch {
            completionHandler(.failure(.canNotCreateCSVReader))
            return
        }

        var failureCount = 0
        var successCount = 0

        let titleRows = getRowsHeaderCellsWithSimilarValue(reader: reader, target: "title")

        if titleRows.count != 1 {
            completionHandler(.failure(.missingUniqueTitleColumn))
            return
        }

        func processNextRow(reader: CSVReader) -> Void {
            if reader.next() == nil {
                completionHandler(.success(CompletionInformation(
                    failureCount: failureCount,
                    successCount: successCount
                )))
                return
            }

            if self.isValidRow(row: reader) {
                let title = self.getValue(row: reader, header: "title") ?? ""
                let description = self.getValue(row: reader, header: "description") ?? ""
                let priority = Int(self.getValue(row: reader, header: "priority") ?? "") ?? 0
                let stateId = self.getValue(row: reader, header: "state") ?? nil
                let assigneeId = self.getValue(row: reader, header: "assignee") ?? nil
                let labelIds = self.getLabelIds(row: reader)

                self.client.perform(mutation: CreateIssueMutation(
                    teamId: teamId,
                    title: title,
                    description: description,
                    priority:priority,
                    labelIds:labelIds,
                    stateId: stateId,
                    assigneeId: assigneeId
                )) { result in
                    switch result {
                        case .success(let result):
                            if let errors = result.errors {
                                failureCount += 1
                                debugPrint(errors)
                            } else {
                                successCount += 1
                            }
                        case .failure(let error):
                            debugPrint(error)
                            failureCount += 1
                    }

                    onUpdate(CompletionInformation(
                        failureCount: failureCount,
                        successCount: successCount
                    ))
                    
                    processNextRow(reader: reader)
                }
            } else {
                failureCount += 1
                
                onUpdate(CompletionInformation(
                    failureCount: failureCount,
                    successCount: successCount
                ))
                
                processNextRow(reader: reader)
            }
        }
        
        processNextRow(reader: reader)
    }
}
