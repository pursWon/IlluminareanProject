import UIKit
import Moya

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    let url: String = "https://api.github.com/search/users?q="
    let provider = MoyaProvider<GitHubApi>()
    
    var userInform: [Inform] = []
    var imageData: [UIImage]?
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHiddenButton()
        setTableView()
        setSearchBar()
    }
    
    func setHiddenButton() {
        cancelButton.isHidden = true
        emptyLabel.isHidden = true
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.isSearchResultsButtonSelected = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView = nil
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).rightView = nil
    }
    
    // func setUserData(url: String) {
    //     let headers: HTTPHeaders = ["Accept": "application/vnd.github+json", "Authorization": "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"]
    //
    //     AF.request(url, method: .get, headers: headers).responseDecodable(of: Users.self) { response in
    //         if let data = response.value {
    //             self.userInform = data.items
    //
    //             if !self.userInform.isEmpty {
    //                 self.emptyLabel.isHidden = true
    //             } else {
    //                 self.emptyLabel.isHidden = false
    //             }
    //         } else {
    //             self.emptyLabel.isHidden = false
    //         }
    //
    //         self.tableView.reloadData()
    //     }
    // }
    
    func setProvideData(query: String) {
        provider.request(.searchUser(query: query)) { result in
            switch result {
            case .success(let response):
                print("search: \(response)")
                let data = try! JSONDecoder().decode(Users.self, from: response.data)
                self.userInform = data.items
                
                if !self.userInform.isEmpty {
                    self.emptyLabel.isHidden = true
                } else {
                    self.emptyLabel.isHidden = false
                }
                
                self.tableView.reloadData()
            case .failure(let error):
                print("error : \(error)")
            }
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let text = searchBar.text else { return }
        
        setProvideData(query: text)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        searchBar.text = ""
        cancelButton.isHidden = true
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInform.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchCell else { return UITableViewCell() }
        
        cell.userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.userNameLabel.text = userInform[indexPath.row].login
        cell.userUrlLabel.text = userInform[indexPath.row].html_url
        
        guard let imageUrl = URL(string: userInform[indexPath.row].avatar_url) else { return UITableViewCell() }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.userImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urls = URL(string: userInform[indexPath.row].html_url) else { return }
        
        UIApplication.shared.open(urls)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        if !text.isEmpty {
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
