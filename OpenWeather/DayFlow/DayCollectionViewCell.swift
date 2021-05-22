
import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellView()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: CachedDaily) {
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd/MM E"
        dateLabel.text = formatter.string(from: date as Date).uppercased()
    }
    
    func configureSelectedItem() {
        contentView.backgroundColor = Colors.mainColor
        dateLabel.textColor = .white
    }
    
    func configureUnselectedItem() {
        contentView.backgroundColor = .white
        dateLabel.textColor = .black
    }
    
    private func setupCellView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
    }
    
    private func setupLayout() {
        contentView.addSubviews(dateLabel)
        
        let constraints = [
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
