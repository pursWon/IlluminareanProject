import UIKit
import Moya
import Kingfisher
import Then

class SearchViewController: UIViewController {
    // MARK: Properties
    let viewModel = SearchViewModel()
    let searchView = SearchView()
    /// 한 페이지당 가지고 있는 검색 결과의 수
    let perPage: Int = 30
    
    // MARK: View Life Cycle
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: Configure
    func configure() {
        setupDelegates()
        setButtonAction()
    }
    
    func setupDelegates() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.prefetchDataSource = self
        searchView.searchBar.delegate = self
    }
    
    func setButtonAction() {
        searchView.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        searchView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    
    // MARK: ETC
    func fetchData() {
        guard let text = searchView.searchBar.text else { return }
        
        viewModel.getUserData(param: (text, viewModel.pageNum), emptyLabel: searchView.emptyLabel, tableView: searchView.tableView)
        // pageNum은 2
    }
    
    func getTotalPage() -> Int { // 전체 페이지 개수를 알아내는 함수
        if viewModel.totalCount % perPage == 0 { // 모든 Data 개수에서 perPage(30)을 나눴을 때 0일 경우,
            return viewModel.totalCount / perPage // 나눈 값을 return
        } else {
            return viewModel.totalCount / perPage + 1 // 나눈 값에 1을 더해서 return
        }
    }
    
    func getSearchedDataByNewKeyword() {
        viewModel.imageURL = []
        viewModel.userInform = []
        viewModel.pageNum = 1
        
        fetchData()
    }
    
    // MARK: Actions
    @objc func searchButtonClicked() {
        getSearchedDataByNewKeyword()
    }
    
    @objc func cancelButtonClicked() {
        searchView.searchBar.text = ""
        searchView.cancelButton.isHidden = true
    }
}

// MARK: UITableViewDataSource & Delegate
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

// MARK: UITableViewDataSourcePrefetching
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if viewModel.pageNum < getTotalPage() { // ex) 1 < 3
            if viewModel.userInform.count == viewModel.pageNum * perPage { // ex) 30 = 1 * 30
                viewModel.pageNum += 1 // 1 + 1 = 2
                fetchData()
            }
        }
    }
}

// MARK: UISearchbarDelefate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        searchView.cancelButton.isHidden = text.isEmpty ? true : false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearchedDataByNewKeyword()
        searchBar.resignFirstResponder()
    }
}

