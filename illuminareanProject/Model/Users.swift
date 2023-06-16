import Foundation
import Moya

enum GitHubApi {
    case searchUser(query: String)
}

extension GitHubApi: TargetType {
    var baseURL: URL {
        let url: String = "https://api.github.com"
        return URL(string: url)!
    }
    
    var path: String {
        switch self {
        case .searchUser:
            return "search/users"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .searchUser(let query):
            return .requestParameters(parameters: ["q" : query], encoding: URLEncoding.default)
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/vnd.github+json", "Authorization": "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"]
    }
}
