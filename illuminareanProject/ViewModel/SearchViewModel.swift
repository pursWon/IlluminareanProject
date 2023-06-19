import UIKit
import Moya

class SearchViewModel {
    let provider = MoyaProvider<GitHubApi>()
    
    var userInform: [Inform] = []
    var imageURL: [URL] = []
    var imageData: [UIImage] = []
    var pageNum: Int = 1
    var totalCount: Int = 0
    
    func setProvideData(query: (String, Int), emptyLabel: UILabel, tableView: UITableView) {
        provider.request(.searchUser(query: query)) { result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(Users.self, from: response.data)
                self.userInform += data.items
                self.totalCount = data.totalCount
                
                self.userInform.forEach {
                    if let url = URL(string: $0.avatarUrl) {
                        self.imageURL.append(url)
                    }
                }
                
                if self.userInform.isEmpty {
                    emptyLabel.isHidden = false
                } else {
                    emptyLabel.isHidden = true
                }
                
                tableView.reloadData()
            
            case .failure(let error):
                print("error : \(error.localizedDescription)")
            }
        }
    }
}
