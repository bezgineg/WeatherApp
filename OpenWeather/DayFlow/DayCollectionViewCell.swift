
import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextBlackColor
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
    
    func configure(with object: Daily) {
        let date = NSDate(timeIntervalSince1970: TimeInterval(object.dt))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd/MM E"
        dateLabel.text = formatter.string(from: date as Date).uppercased()
        if isSelected {
            configureSelectedItem()
        } else {
            configureUnselectedItem()
        }
    }
    
    func configureSelectedItem() {
        contentView.backgroundColor = Colors.mainColor
        dateLabel.textColor = Colors.primaryTextWhiteColor
    }
    
    func configureUnselectedItem() {
        contentView.backgroundColor = Colors.primaryBackgroundWhiteColor
        dateLabel.textColor = Colors.primaryTextBlackColor
    }
    
    private func setupCellView() {
        contentView.backgroundColor = Colors.primaryBackgroundWhiteColor
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
