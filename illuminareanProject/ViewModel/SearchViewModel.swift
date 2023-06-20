import UIKit
import Moya

/// Github Search API 통신을 위해 준수해야할 프로토콜 (사용한 함수들을 명세)
protocol SearchAPIProtocol {
    func getUserData(param: (query: String, page: Int), emptyLabel: UILabel, tableView: UITableView)
}

class SearchViewModel: SearchAPIProtocol {
    let provider = MoyaProvider<GitHubApi>()
    
    var userInform: [Inform] = []
    var imageURL: [URL] = []
    var imageData: [UIImage] = []
    var pageNum: Int = 1
    var totalCount: Int = 0
    
    func getUserData(param: (query: String, page: Int), emptyLabel: UILabel, tableView: UITableView) {
        provider.request(.searchUser(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(Users.self, from: response.data)
                    self.userInform += data.items
                    self.totalCount = data.totalCount
                    
                    data.items.forEach {
                        if self.imageURL.count < self.totalCount {
                            if let url = URL(string: $0.avatarUrl) {
                                self.imageURL.append(url)
                            }
                        }
                    }
                }
                catch {
                    print("fail to decode - \(error.localizedDescription)")
                }

                emptyLabel.isHidden = self.userInform.isEmpty ? false : true
                tableView.reloadData()
                
            case .failure(let error):
                print("fail to urlsession - \(error.localizedDescription)")
            }
        }
    }
}

