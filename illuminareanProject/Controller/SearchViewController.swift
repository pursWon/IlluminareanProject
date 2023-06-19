import UIKit
import Moya
import Kingfisher
import Then

class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    let searchView = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = searchView
        
        setTableView()
        setSearchBar()
        setButtonAction()
    }
    
    func setTableView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
    }
    
    func setSearchBar() {
        searchView.searchBar.delegate = self
    }
    
    func setButtonAction() {
        searchView.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        searchView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    
    @objc func searchButtonClicked() {
        guard let text = searchView.searchBar.text else { return }
        print(text)
        
        viewModel.setProvideData(query: text, emptyLabel: searchView.emptyLabel, tableView: searchView.tableView)
    }
    
    @objc func cancelButtonClicked() {
        searchView.searchBar.text = ""
        searchView.cancelButton.isHidden = true
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userInform.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        
        cell.nameLabel.text = viewModel.userInform[indexPath.row].login
        cell.urlLabel.text = viewModel.userInform[indexPath.row].html_url
        
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
        return 130
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        if !text.isEmpty {
            searchView.cancelButton.isHidden = false
        } else {
            searchView.cancelButton.isHidden = true
        }
    }
}
