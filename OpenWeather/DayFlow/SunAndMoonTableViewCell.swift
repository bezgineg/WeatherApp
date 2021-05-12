
import UIKit

class SunAndMoonTableViewCell: UITableViewCell {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.text = "Солнце и Луна"
        return label
    }()
    
    private let moonPhaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let moonPhaseImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        contentView.layer.cornerRadius = 5
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: Daily) {
        contentView.backgroundColor = .white
        setupMoonPhase(moonphase: object.moonPhase)
    }
    
    private func setupMoonPhase(moonphase: Double) {
        switch moonphase {
        case 0, 1:
            moonPhaseLabel.text = "Новолуние"
            moonPhaseImage.image = UIImage(named: "newMoon")?.withTintColor(Colors.moonPhaseColor)
        case 0..<0.25:
            moonPhaseLabel.text = "Молодая луна"
            moonPhaseImage.image = UIImage(named: "waxingCrescent")?.withTintColor(Colors.moonPhaseColor)
        case 0.25:
            moonPhaseLabel.text = "Первая четверть луны"
            moonPhaseImage.image = UIImage(named: "firstQuarter")?.withTintColor(Colors.moonPhaseColor)
        case 0.25..<0.5:
            moonPhaseLabel.text = "Прибывающая луна"
            moonPhaseImage.image = UIImage(named: "waxingGibbous")?.withTintColor(Colors.moonPhaseColor)
        case 0.5:
            moonPhaseLabel.text = "Полнолуние"
            moonPhaseImage.image = UIImage(named: "fullMoon")?.withTintColor(Colors.moonPhaseColor)
        case 0.5..<0.75:
            moonPhaseLabel.text = "Убывающая луна"
            moonPhaseImage.image = UIImage(named: "waningGibbous")?.withTintColor(Colors.moonPhaseColor)
        case 0.75:
            moonPhaseLabel.text = "Последняя четверть луны"
            moonPhaseImage.image = UIImage(named: "lastQuarter")?.withTintColor(Colors.moonPhaseColor)
        case 0.75..<1:
            moonPhaseLabel.text = "Старая луна"
            moonPhaseImage.image = UIImage(named: "waningCrescent")?.withTintColor(Colors.moonPhaseColor)
        default:
            moonPhaseLabel.text = ""
        }
    }
    
    private func setupLayout() {
        
        contentView.addSubviews(mainLabel, moonPhaseLabel, moonPhaseImage)
        
        let constraints = [
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            moonPhaseLabel.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
            moonPhaseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            moonPhaseImage.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
            moonPhaseImage.trailingAnchor.constraint(equalTo: moonPhaseLabel.leadingAnchor, constant: -5),
            moonPhaseImage.widthAnchor.constraint(equalToConstant: 15),
            moonPhaseImage.heightAnchor.constraint(equalToConstant: 15),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
