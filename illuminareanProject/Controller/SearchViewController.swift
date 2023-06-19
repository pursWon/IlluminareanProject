import UIKit
import Moya
import Kingfisher
import Then

class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    let searchBar: UISearchBar = UISearchBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let searchButton: UIButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(image, for: .normal)
        $0.tintColor = .orange
    }
    
    let cancelButton: UIButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    
    let emptyLabel: UILabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "검색 결과가 존재하지 않습니다."
        $0.font = .boldSystemFont(ofSize: 21)
    }
    
    let tableView: UITableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var isPaging: Bool = false
    var hasNextPage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setContraints()
        setTableView()
        setSearchBar()
        setButtonAction()
        setHiddenButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func paging() {
        guard let text = searchBar.text else { return }
        
        let index = viewModel.userInform.count
        var datas: [Inform] = []
        
        viewModel.setProvideData(query: text, emptyLabel: emptyLabel, tableView: tableView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
        }
    }
    
    func setView() {
        let views: [UIView] = [tableView, searchBar, searchButton, cancelButton, emptyLabel]
        view.backgroundColor = .white
        
        views.forEach {
            view.addSubview($0)
        }
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
    }
    
    func setButtonAction() {
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.isSearchResultsButtonSelected = true
        
        let searchBarStyle = searchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView = nil
    }
    
    func setHiddenButton() {
        cancelButton.isHidden = true
        emptyLabel.isHidden = true
    }
    
    func setContraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 10).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 0).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -30).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func searchButtonClicked() {
        guard let text = searchBar.text else { return }
        
        viewModel.setProvideData(query: text, emptyLabel: emptyLabel, tableView: tableView)
    }
    
    @objc func cancelButtonClicked() {
        searchBar.text = ""
        cancelButton.isHidden = true
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
        return 120
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

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let text = searchBar.text else { return }

        let contentOffset_y = scrollView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        let pagination_y = tableViewContentSize * 0.2

        if contentOffset_y > tableViewContentSize - pagination_y {
            viewModel.setProvideData(query: text, emptyLabel: emptyLabel, tableView: tableView)
            print(4)
        }
    }
}
