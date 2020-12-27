// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class CreateIssueMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateIssue($teamId: String!, $title: String!, $projectId: String, $description: String, $priority: Int) {
      issueCreate(
        input: {teamId: $teamId, projectId: $projectId, title: $title, description: $description, priority: $priority}
      ) {
        __typename
        success
      }
    }
    """

  public let operationName: String = "CreateIssue"

  public let operationIdentifier: String? = "fd656055f9d36860e025ac7271800babf07f9d2fea5831af7f4a4fab9f1773a7"

  public var teamId: String
  public var title: String
  public var projectId: String?
  public var description: String?
  public var priority: Int?

  public init(teamId: String, title: String, projectId: String? = nil, description: String? = nil, priority: Int? = nil) {
    self.teamId = teamId
    self.title = title
    self.projectId = projectId
    self.description = description
    self.priority = priority
  }

  public var variables: GraphQLMap? {
    return ["teamId": teamId, "title": title, "projectId": projectId, "description": description, "priority": priority]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("issueCreate", arguments: ["input": ["teamId": GraphQLVariable("teamId"), "projectId": GraphQLVariable("projectId"), "title": GraphQLVariable("title"), "description": GraphQLVariable("description"), "priority": GraphQLVariable("priority")]], type: .nonNull(.object(IssueCreate.selections))),
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
        id
        issues(first: $first, after: $after) {
          __typename
          nodes {
            __typename
            id
            title
            estimate
            createdAt
            updatedAt
            archivedAt
            description
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

  public let operationIdentifier: String? = "f2dcc063202a24bb27350dc7e3afe9494dcef12d1e958db28ed813f6b7441d8b"

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
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("issues", arguments: ["first": GraphQLVariable("first"), "after": GraphQLVariable("after")], type: .nonNull(.object(Issue.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, issues: Issue) {
        self.init(unsafeResultMap: ["__typename": "Team", "id": id, "issues": issues.resultMap])
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
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("estimate", type: .scalar(Double.self)),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("archivedAt", type: .scalar(String.self)),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("assignee", type: .object(Assignee.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, title: String, estimate: Double? = nil, createdAt: String, updatedAt: String, archivedAt: String? = nil, description: String? = nil, assignee: Assignee? = nil) {
            self.init(unsafeResultMap: ["__typename": "Issue", "id": id, "title": title, "estimate": estimate, "createdAt": createdAt, "updatedAt": updatedAt, "archivedAt": archivedAt, "description": description, "assignee": assignee.flatMap { (value: Assignee) -> ResultMap in value.resultMap }])
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

          /// The time at which the entity was created.
          public var createdAt: String {
            get {
              return resultMap["createdAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// The last time at which the entity was updated. This is the same as the creation time if the
          /// entity hasn't been update after creation.
          public var updatedAt: String {
            get {
              return resultMap["updatedAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "updatedAt")
            }
          }

          /// The time at which the entity was archived. Null if the entity has not been archived.
          public var archivedAt: String? {
            get {
              return resultMap["archivedAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "archivedAt")
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

          /// The user to whom the issue is assigned to.
          public var assignee: Assignee? {
            get {
              return (resultMap["assignee"] as? ResultMap).flatMap { Assignee(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "assignee")
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
