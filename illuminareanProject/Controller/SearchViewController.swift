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
        searchView.tableView.prefetchDataSource = self
    }
    
    func setSearchBar() {
        searchView.searchBar.delegate = self
    }
    
    func setButtonAction() {
        searchView.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        searchView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    
    func fetchData() {
        guard let text = searchView.searchBar.text else { return }
        
        if viewModel.totalCount > viewModel.userInform.count {
            viewModel.setProvideData(query: (text, viewModel.pageNum), emptyLabel: searchView.emptyLabel, tableView: searchView.tableView)
        }
    }
    
    func getTotalPage() -> Int {
        if viewModel.totalCount % 30 == 0 {
            return viewModel.totalCount / 30
        } else {
            return viewModel.totalCount / 30 + 1
        }
    }
    
    @objc func searchButtonClicked() {
        viewModel.imageURL = []
        viewModel.userInform = []
        viewModel.pageNum = 1
        
        fetchData()
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
        cell.urlLabel.text = viewModel.userInform[indexPath.row].htmlUrl
        
        if viewModel.imageURL.count == viewModel.userInform.count {
            cell.userImageView.kf.setImage(with: viewModel.imageURL[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urls = URL(string: viewModel.userInform[indexPath.row].htmlUrl) else { return }
        
        UIApplication.shared.open(urls)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if viewModel.pageNum < getTotalPage() {
            viewModel.pageNum += 1
            fetchData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        if text.isEmpty {
            searchView.cancelButton.isHidden = true
        } else {
            searchView.cancelButton.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchView.searchBar.text else { return }
        
        viewModel.imageURL = []
        viewModel.userInform = []
        viewModel.pageNum = 1
        viewModel.setProvideData(query: (text, viewModel.pageNum), emptyLabel: searchView.emptyLabel, tableView: searchView.tableView)
        searchBar.resignFirstResponder()
    }
}
