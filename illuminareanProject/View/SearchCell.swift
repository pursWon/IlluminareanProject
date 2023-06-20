import UIKit
import Then

class CustomCell: UITableViewCell, UIProtocol {
    // MARK: Properties
    static let identifier = "CustomCell"
    
    // MARK: UI
    let nameLabel: UILabel = UILabel().then {
        $0.text = "name"
        $0.font = .boldSystemFont(ofSize: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let urlLabel: UILabel = UILabel().then {
        $0.text = "url"
        $0.font = .boldSystemFont(ofSize: 13)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let userImageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .red
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func configure() {
        setViews()
        setContraints()
    }
    
    func setViews() {
        let views: [UIView] = [nameLabel, urlLabel, userImageView]
        views.forEach { contentView.addSubview($0) }
    }
    
    func setContraints() {
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 150).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100).isActive = true
        
        urlLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 150).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        userImageView.trailingAnchor.constraint(equalTo: urlLabel.leadingAnchor, constant: -30).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

