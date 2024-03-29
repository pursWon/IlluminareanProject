import UIKit
import Then

class SearchView: UIView, UIProtocol {
    // MARK: UI
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
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func configure() {
        self.backgroundColor = .white
        setViews()
        setTableView()
        setSearchBar()
        setHiddenButton()
        setContraints()
    }
    
    func setViews() {
        let views: [UIView] = [tableView, searchBar, searchButton, cancelButton, emptyLabel]
        views.forEach { self.addSubview($0) }
    }
    
    func setTableView() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
    }
    
    func setSearchBar() {
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
        tableView.topAnchor.constraint(equalTo: topAnchor, constant: 150).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
        searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        
        searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 10).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        
        cancelButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -30).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 10).isActive = true
        
        emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

