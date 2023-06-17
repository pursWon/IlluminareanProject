import UIKit
import Moya

class SearchViewModel {
    let url: String = "https://api.github.com/search/users?q="
    let provider = MoyaProvider<GitHubApi>()
    
    var userInform: [Inform] = []
    var imageURL: [URL] = []
    var imageData: [UIImage] = []
    
    func setProvideData(query: String, emptyLabel: UILabel, tableView: UITableView) {
        provider.request(.searchUser(query: query)) { result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(Users.self, from: response.data)
                self.imageURL = []
                self.userInform = data.items
               
                if !self.userInform.isEmpty {
                    emptyLabel.isHidden = true
                } else {
                    emptyLabel.isHidden = false
                }
                
                self.userInform.forEach {
                    if let url = URL(string: $0.avatar_url) {
                        self.imageURL.append(url)
                    }
                }
                
                tableView.reloadData()
                
            case .failure(let error):
                print("error : \(error)")
            }
        }
    }
}
