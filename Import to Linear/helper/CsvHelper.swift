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
            try csv.write(row: ["id", "title", "description", "estimate"])
        } catch {
            completionHandler(.failure(.unableToWriteHeader))
            return
        }

        var failureCount = 0
        var successCount = 0

        getAllTeamIssues(teamId: teamId, issueHandler: { issue in
            let estimateColumn: String

            if let estimate: Double = issue.estimate {
                estimateColumn = String(format: "%.1f", estimate)
            } else {
                estimateColumn = ""
            }

            do {
                try csv.write(row: [issue.id, issue.title, issue.description ?? "", estimateColumn])
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

    func createWritableCSVFile(completionHandler: @escaping (Result<URL, CreateCSVError>) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let dateformat = DateFormatter()
                dateformat.dateFormat = "yyyy-MM-dd-HH-mm-ss"
                let fileName = dateformat.string(from: Date())

                let filePath = URL(string: openPanel.url!.absoluteString)!.appendingPathComponent("linear-issues-\(fileName)", isDirectory: false).appendingPathExtension("csv")
                let created = FileManager.default.createFile(atPath: filePath.path, contents: "".data(using: .utf8))

                if created {
                    completionHandler(.success(filePath))
                } else {
                    completionHandler(.failure(.unableToCreateFile))
                }
            } else {
                completionHandler(.failure(.userDecline))
            }
        }
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
        let descriptionKey = getRowsHeaderCellsWithSimilarValue(reader: reader, target: "description").first
        let priorityKey = getRowsHeaderCellsWithSimilarValue(reader: reader, target: "priority").first

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

            let title = reader[titleRows.first ?? "title"]
            let description = descriptionKey == nil ? "" : reader[descriptionKey!]
            var priority: Int? = nil

            if let key = priorityKey {
                if let cellString = reader[key],
                   let priorityNumber = Int(cellString),
                   priorityNumber > -1 && priorityNumber < 5 {
                    priority = priorityNumber
                }
            }

            self.client.perform(mutation: CreateIssueMutation(teamId: teamId, title: title!, description: description, priority: priority)) { result in
                switch result {
                    case .success(let result):
                        if let errors = result.errors {
                            failureCount += 1
                            debugPrint(errors)
                        } else {
                            successCount += 1
                        }
                    case .failure:
                        failureCount += 1
                }

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
