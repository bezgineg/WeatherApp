
import UIKit

class PeriodsOfTimeTableViewCell: UITableViewCell {

    private let periodOfTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textColor = .black
        return label
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
    
    func configureDay(with object: Daily) {
        contentView.backgroundColor = Colors.customBackgroundColor
        periodOfTimeLabel.text = "День"
        setupWeatherImage(weather: object.weather.first?.main.rawValue)
        temperatureLabel.text = "\(Int(object.temp.day))°"
    }
    
    private func setupWeatherImage(weather: String?) {
        switch weather {
        case "Clear":
            weatherImage.image = UIImage(named: "sun")
        case "Rain":
            weatherImage.image = UIImage(named: "rain")
        case "Clouds":
            weatherImage.image = UIImage(named: "clouds")
        default:
            break
        }
    }
    
    private func setupLayout() {

        contentView.addSubview(periodOfTimeLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(temperatureLabel)
        
        let constraints = [
            periodOfTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            periodOfTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            weatherImage.leadingAnchor.constraint(equalTo: periodOfTimeLabel.trailingAnchor, constant: 75),
            weatherImage.widthAnchor.constraint(equalToConstant: 26),
            weatherImage.heightAnchor.constraint(equalToConstant: 32),
            
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 10),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
