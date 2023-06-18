import UIKit
import Moya
import Kingfisher
import Then

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    let viewModel = SearchViewModel()
    
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
        let searchBarStyle = searchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView = nil
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let text = searchBar.text else { return }
        
        viewModel.setProvideData(query: text, emptyLabel: emptyLabel, tableView: tableView)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        searchBar.text = ""
        cancelButton.isHidden = true
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userInform.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchCell else { return UITableViewCell() }
        
        cell.userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.userNameLabel.text = viewModel.userInform[indexPath.row].login
        cell.userUrlLabel.text = viewModel.userInform[indexPath.row].html_url
        
        if viewModel.imageURL.count == viewModel.userInform.count {
            cell.userImageView.kf.setImage(with: viewModel.imageURL[indexPath.row])
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urls = URL(string: viewModel.userInform[indexPath.row].html_url) else { return }
        
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
}
