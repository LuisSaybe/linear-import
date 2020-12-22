import CSV
import Foundation
import Apollo
import AuthenticationServices

struct UploadInformation {
    var failureCount: Int
    var successCount: Int
}

class CsvUtility {
    let client: ApolloClient

    init(client: ApolloClient) {
        self.client = client
    }

    func writeTeamIssuesToDownloads(teamId: String) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin
            { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue
                {
                    /*
                    let filePath = URL(string: openPanel.url!.absoluteString)!.appendingPathComponent("macOS.csv", isDirectory: false)
                    let created = FileManager.default.createFile(atPath: filePath.path, contents: "".data(using: .utf8))

                    debugPrint("filePath", filePath.path)
                    
                    if !created {
                        print("Unable to create file")
                        return
                    }

                    let stream = OutputStream(url: filePath, append: false)!
                    let csv = try! CSVWriter(stream: stream)

                     try! csv.write(row: ["id", "title"])
                    */
                    self.client.fetch(query: GetTeamIssuesQuery(teamId: teamId)) { response in
                        switch response {
                            case .success(let result):
                                debugPrint(result.errors)
                                
                                for issue in result.data?.team.issues.nodes ?? [] {
                                    print("issue \(issue)")
                                    // try! csv.write(row: [issue.id, issue.title])
                                }
                                // csv.stream.close()
                            case .failure(let error):
                              print("Failure! Error: \(error)")
                                // csv.stream.close()
                        }
                      }

                    // csv.stream.close()
                }
        }
        
        print("Exited!!")
    }
    
    func uploadToLinearTeam(teamId: String, file: URL) -> UploadInformation {
        let stream = InputStream(url: file)!
        let csv = try! CSVReader(stream: stream,
                                 hasHeaderRow: true)
        var failureCount = 0
        var successCount = 0
        
        while csv.next() != nil {
            print("\(csv["Title"]!)")
            print("\(csv["Description"]!)")
            print("\(csv["Estimate"]!)")
            print("\(csv["ID"]!)")
        }
        
        return UploadInformation(
            failureCount: failureCount,
            successCount: successCount
        )
    }
}
