// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class CreateIssueMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateIssue($teamId: String!, $title: String!, $description: String, $priority: Int, $labelIds: [String!], $stateId: String, $assigneeId: String) {
      issueCreate(
        input: {teamId: $teamId, title: $title, description: $description, priority: $priority, labelIds: $labelIds, stateId: $stateId, assigneeId: $assigneeId}
      ) {
        __typename
        success
      }
    }
    """

  public let operationName: String = "CreateIssue"

  public let operationIdentifier: String? = "dc3a21053611452bd0d63f5f868a158e8fe85399f58ccba439c876ccd66c3acd"

  public var teamId: String
  public var title: String
  public var description: String?
  public var priority: Int?
  public var labelIds: [String]?
  public var stateId: String?
  public var assigneeId: String?

  public init(teamId: String, title: String, description: String? = nil, priority: Int? = nil, labelIds: [String]?, stateId: String? = nil, assigneeId: String? = nil) {
    self.teamId = teamId
    self.title = title
    self.description = description
    self.priority = priority
    self.labelIds = labelIds
    self.stateId = stateId
    self.assigneeId = assigneeId
  }

  public var variables: GraphQLMap? {
    return ["teamId": teamId, "title": title, "description": description, "priority": priority, "labelIds": labelIds, "stateId": stateId, "assigneeId": assigneeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("issueCreate", arguments: ["input": ["teamId": GraphQLVariable("teamId"), "title": GraphQLVariable("title"), "description": GraphQLVariable("description"), "priority": GraphQLVariable("priority"), "labelIds": GraphQLVariable("labelIds"), "stateId": GraphQLVariable("stateId"), "assigneeId": GraphQLVariable("assigneeId")]], type: .nonNull(.object(IssueCreate.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(issueCreate: IssueCreate) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "issueCreate": issueCreate.resultMap])
    }

    /// Creates a new issue.
    public var issueCreate: IssueCreate {
      get {
        return IssueCreate(unsafeResultMap: resultMap["issueCreate"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "issueCreate")
      }
    }

    public struct IssueCreate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["IssuePayload"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("success", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(success: Bool) {
        self.init(unsafeResultMap: ["__typename": "IssuePayload", "success": success])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Whether the operation was successful.
      public var success: Bool {
        get {
          return resultMap["success"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "success")
        }
      }
    }
  }
}

public final class GetTeamIssuesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetTeamIssues($teamId: String!, $first: Int, $after: String) {
      team(id: $teamId) {
        __typename
        issues(first: $first, after: $after) {
          __typename
          nodes {
            __typename
            id
            identifier
            title
            estimate
            priority
            description
            state {
              __typename
              id
            }
            labels {
              __typename
              nodes {
                __typename
                id
              }
            }
            assignee {
              __typename
              id
              name
            }
          }
        }
      }
    }
    """

  public let operationName: String = "GetTeamIssues"

  public let operationIdentifier: String? = "a9b04ad66d308fa904c0c85fe3cd5aeb647c4a446c08e6f45f750f301eb5a6fa"

  public var teamId: String
  public var first: Int?
  public var after: String?

  public init(teamId: String, first: Int? = nil, after: String? = nil) {
    self.teamId = teamId
    self.first = first
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["teamId": teamId, "first": first, "after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("team", arguments: ["id": GraphQLVariable("teamId")], type: .nonNull(.object(Team.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(team: Team) {
      self.init(unsafeResultMap: ["__typename": "Query", "team": team.resultMap])
    }

    /// One specific team.
    public var team: Team {
      get {
        return Team(unsafeResultMap: resultMap["team"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "team")
      }
    }

    public struct Team: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Team"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("issues", arguments: ["first": GraphQLVariable("first"), "after": GraphQLVariable("after")], type: .nonNull(.object(Issue.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(issues: Issue) {
        self.init(unsafeResultMap: ["__typename": "Team", "issues": issues.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Issues associated with the team.
      public var issues: Issue {
        get {
          return Issue(unsafeResultMap: resultMap["issues"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "issues")
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["IssueConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .nonNull(.list(.nonNull(.object(Node.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node]) {
          self.init(unsafeResultMap: ["__typename": "IssueConnection", "nodes": nodes.map { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nodes: [Node] {
          get {
            return (resultMap["nodes"] as! [ResultMap]).map { (value: ResultMap) -> Node in Node(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Node) -> ResultMap in value.resultMap }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Issue"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("identifier", type: .nonNull(.scalar(String.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("estimate", type: .scalar(Double.self)),
              GraphQLField("priority", type: .nonNull(.scalar(Double.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("state", type: .nonNull(.object(State.selections))),
              GraphQLField("labels", type: .nonNull(.object(Label.selections))),
              GraphQLField("assignee", type: .object(Assignee.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, identifier: String, title: String, estimate: Double? = nil, priority: Double, description: String? = nil, state: State, labels: Label, assignee: Assignee? = nil) {
            self.init(unsafeResultMap: ["__typename": "Issue", "id": id, "identifier": identifier, "title": title, "estimate": estimate, "priority": priority, "description": description, "state": state.resultMap, "labels": labels.resultMap, "assignee": assignee.flatMap { (value: Assignee) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The unique identifier of the entity.
          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// Issue's human readable identifier (e.g. ENG-123).
          public var identifier: String {
            get {
              return resultMap["identifier"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "identifier")
            }
          }

          /// The issue's title.
          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          /// The estimate of the complexity of the issue..
          public var estimate: Double? {
            get {
              return resultMap["estimate"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "estimate")
            }
          }

          /// The priority of the issue.
          public var priority: Double {
            get {
              return resultMap["priority"]! as! Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "priority")
            }
          }

          /// The issue's description in markdown format.
          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          /// The workflow state that the issue is associated with.
          public var state: State {
            get {
              return State(unsafeResultMap: resultMap["state"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "state")
            }
          }

          /// Labels associated with this issue.
          public var labels: Label {
            get {
              return Label(unsafeResultMap: resultMap["labels"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "labels")
            }
          }

          /// The user to whom the issue is assigned to.
          public var assignee: Assignee? {
            get {
              return (resultMap["assignee"] as? ResultMap).flatMap { Assignee(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "assignee")
            }
          }

          public struct State: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["WorkflowState"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID) {
              self.init(unsafeResultMap: ["__typename": "WorkflowState", "id": id])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The unique identifier of the entity.
            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }
          }

          public struct Label: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["IssueLabelConnection"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("nodes", type: .nonNull(.list(.nonNull(.object(Node.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(nodes: [Node]) {
              self.init(unsafeResultMap: ["__typename": "IssueLabelConnection", "nodes": nodes.map { (value: Node) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var nodes: [Node] {
              get {
                return (resultMap["nodes"] as! [ResultMap]).map { (value: ResultMap) -> Node in Node(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: Node) -> ResultMap in value.resultMap }, forKey: "nodes")
              }
            }

            public struct Node: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["IssueLabel"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID) {
                self.init(unsafeResultMap: ["__typename": "IssueLabel", "id": id])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The unique identifier of the entity.
              public var id: GraphQLID {
                get {
                  return resultMap["id"]! as! GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }
            }
          }

          public struct Assignee: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["User"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, name: String) {
              self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The unique identifier of the entity.
            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            /// The user's full name.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }
          }
        }
      }
    }
  }
}

public final class GetTeamsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetTeams($first: Int, $after: String) {
      teams(first: $first, after: $after) {
        __typename
        nodes {
          __typename
          id
          name
          description
        }
      }
    }
    """

  public let operationName: String = "GetTeams"

  public let operationIdentifier: String? = "d31296a981ec59c904e044b4ae9f2031e4da75b46f3b32a22bb9c05686b79152"

  public var first: Int?
  public var after: String?

  public init(first: Int? = nil, after: String? = nil) {
    self.first = first
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["first": first, "after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("teams", arguments: ["first": GraphQLVariable("first"), "after": GraphQLVariable("after")], type: .nonNull(.object(Team.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(teams: Team) {
      self.init(unsafeResultMap: ["__typename": "Query", "teams": teams.resultMap])
    }

    /// All teams.
    public var teams: Team {
      get {
        return Team(unsafeResultMap: resultMap["teams"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "teams")
      }
    }

    public struct Team: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TeamConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nodes", type: .nonNull(.list(.nonNull(.object(Node.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nodes: [Node]) {
        self.init(unsafeResultMap: ["__typename": "TeamConnection", "nodes": nodes.map { (value: Node) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nodes: [Node] {
        get {
          return (resultMap["nodes"] as! [ResultMap]).map { (value: ResultMap) -> Node in Node(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Node) -> ResultMap in value.resultMap }, forKey: "nodes")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Team"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("description", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, description: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Team", "id": id, "name": name, "description": description])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The unique identifier of the entity.
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// The team's name.
        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// The team's description.
        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }
      }
    }
  }
}
