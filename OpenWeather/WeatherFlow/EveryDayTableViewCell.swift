
import UIKit

class EveryDayTableViewCell: UITableViewCell {
    
    var storage: StorageService?
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = Colors.primaryTextGrayColor
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.mainColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextBlackColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextBlackColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let vectorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "vector")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.primaryBackgroundWhiteColor
        contentView.backgroundColor = Colors.customBackgroundColor
        contentView.layer.cornerRadius = 5
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: CachedDaily) {
        setupDayLabel(day: object.dt)
        setupTemperature(object: object)
        humidityLabel.text = "\(object.humidity)%"
        setupWeatherImage(weather: object.weathers.first?.mainEnum.rawValue)
        descriptionLabel.text = "\(object.weathers.first?.weatherDescriptionEnum.rawValue ?? "")".capitalizingFirstLetter()
    }
    
    private func setupTemperature(object: CachedDaily) {
        guard let storage = storage else { return }

        if storage.isCelsiusChosenBoolKey {
            temperatureLabel.text = "\(Int(object.temp?.min ?? 0))°-\(Int(object.temp?.max ?? 0))°"
        } else {
            let minTemp = fahrenheitConversion(object.temp?.min ?? 0)
            let maxTemp = fahrenheitConversion(object.temp?.max ?? 0)
            temperatureLabel.text = "\(minTemp)°-\(maxTemp)°"
        }
    }
    
    private func setupDayLabel(day: Int) {
        let date = NSDate(timeIntervalSince1970: TimeInterval(day))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        dayLabel.text = formatter.string(from: date as Date)
    }
    
    private func setupWeatherImage(weather: String?) {
        switch weather {
        case "Clear":
            weatherImage.image = UIImage(named: "sun")
        case "Rain":
            weatherImage.image = UIImage(named: "rain")
        case "Clouds":
            weatherImage.image = UIImage(named: "clouds")
        case "Drizzle":
            weatherImage.image = UIImage(named: "drizzle")
        default:
            break
        }
    }
    
    private func setupLayout() {

        contentView.addSubviews(dayLabel, weatherImage, humidityLabel, descriptionLabel, temperatureLabel, vectorImage)
        
        let constraints = [
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            weatherImage.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
            weatherImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            weatherImage.widthAnchor.constraint(equalToConstant: 15),
            weatherImage.heightAnchor.constraint(equalToConstant: 17),
            
            humidityLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 5),
            humidityLabel.centerYAnchor.constraint(equalTo: weatherImage.centerYAnchor),
            
            vectorImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            vectorImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            vectorImage.widthAnchor.constraint(equalToConstant: 6),
            vectorImage.heightAnchor.constraint(equalToConstant: 9),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: vectorImage.leadingAnchor, constant: -10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 66),
            descriptionLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -3),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
