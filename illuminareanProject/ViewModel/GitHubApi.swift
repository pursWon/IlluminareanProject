import Foundation
import Moya

// GitHub API 공식문서, 라이브러리 Moya의 공식문서 및 관련 블로그를 참고
enum GitHubApi {
    case searchUser(param: (query: String, page: Int))
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
    
    var task: Task {
        switch self {
        case .searchUser(let query):
            return .requestParameters(parameters: ["q" : query.0, "page" : query.1], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/vnd.github+json", "Authorization": "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"]
    }
}
