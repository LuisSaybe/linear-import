import SwiftUI
import CSV
import Alamofire

struct TeamNode: Codable {
    var id: String
    var name: String
}

struct TeamNodes: Codable {
    var nodes: [TeamNode]
}

struct TeamsResponse: Codable {
    var teams: TeamNodes
}

struct DataTeamsResponse: Codable {
    var data: TeamsResponse
}

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button(action: {
                let dialog = NSOpenPanel()
                dialog.title                   = "Choose a file"
                dialog.showsResizeIndicator    = true
                dialog.showsHiddenFiles        = false
                dialog.allowsMultipleSelection = false
                dialog.canChooseDirectories = false
                dialog.allowedFileTypes = ["csv"]

                if (dialog.runModal() == NSApplication.ModalResponse.OK) {
                    let stream = InputStream(url: dialog.urls[0])!
                    let csv = try! CSVReader(stream: stream,
                                             hasHeaderRow: true)

                    while csv.next() != nil {
                        print("\(csv["Title"]!)")
                        print("\(csv["Description"]!)")
                        print("\(csv["Estimate"]!)")
                        print("\(csv["ID"]!)")

                        AF.request("https://api.linear.app/graphql", method: .post, parameters: [
                            "query" : """
                              mutation {
                                issueCreate(
                                  input: {
                                    title: "\(csv["Title"]!)"
                                    description: "\(csv["Description"]!)"
                                    estimate: \(csv["Estimate"]!)
                                    teamId: "c4e41f33-8e10-43d5-85ef-03ecadb94d06"
                                  }
                                ) {
                                  success
                                  issue {
                                    id
                                  }
                                }
                              }
                          """,
                        ], encoder: JSONParameterEncoder.default, headers: [
                            "Authorization": ""
                        ]).responseJSON {
                            response in
                            if let data = response.value {
                                 print("JSON: \(data)")
                             }
                        }
                        
                        break
                    }

                    print("done!")
                } else {
                    print("cancelled")
                }
            }, label: {
                Text("Choose file")
            }).padding()
            .onAppear(perform: {
                AF.request("https://api.linear.app/graphql", method: .post, parameters: [
                    "query" : "{ teams { nodes { id name } } }",
                ], encoder: JSONParameterEncoder.default, headers: [
                    "Authorization": ""
                ]).responseString { response in
                    if let data = response.data {
                        let data = try! JSONDecoder().decode(DataTeamsResponse.self, from: data)
                        debugPrint(data)
                    }
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
