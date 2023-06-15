import UIKit
import Alamofire

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    let url: String = "https://api.github.com/search/users?q="
    
    var userInform: [Inform]?
    var imageData: [UIImage]?
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setSearchBar()
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
    }
    
    func setUserData(url: String) {
        let headers: HTTPHeaders = ["Accept": "application/vnd.github+json", "Authorization": "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"]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Users.self) { response in
            if let data = response.value {
                self.userInform = data.items
                self.emptyLabel.isHidden = true
            } else {
                self.userInform = []
                self.emptyLabel.isHidden = false
            }
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let text = searchBar.text else { return }
        
        setUserData(url: url + text)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let inform = userInform else { return 0 }
        
        return inform.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchCell else { return UITableViewCell() }
        
        guard let inform = userInform else { return UITableViewCell() }
        
        cell.userNameLabel.text = inform[indexPath.row].login
        cell.userUrlLabel.text = inform[indexPath.row].url
        
        guard let url = URL(string: inform[indexPath.row].avatar_url) else { return UITableViewCell() }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.userImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFiltering = true
        
    }
    
    // func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //     <#code#>
    // }
    //
    //
    //
    // func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    //     <#code#>
    // }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
