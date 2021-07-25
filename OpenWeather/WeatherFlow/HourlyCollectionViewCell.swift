
import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    var storage: StorageService?
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextGrayColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextBlackColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellView()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: Current) {
        setupTemperature(object)
        setupTimeLabel(time: object.dt)
        setupWeatherImage(weather: object.weather.first?.main.rawValue)
        configureUnselectedItem()
    }
    
    private func setupTemperature(_ object: Current) {
        guard let storage = storage else { return }
        if storage.isCelsiusChosenBoolKey {
            temperatureLabel.text = "\(Int(object.temp))°"
        } else {
            temperatureLabel.text = "\(fahrenheitConversion(object.temp))°"
        }
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
    
    private func setupTimeLabel(time: Int) {
        guard let storage = storage else { return }

        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        if storage.is24TimeFormalChosenBoolKey {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "h:mm"
        }
        timeLabel.text = formatter.string(from: date as Date)
    }
    
    func configureSelectedItem() {
        contentView.backgroundColor = Colors.mainColor
        timeLabel.textColor = Colors.primaryTextWhiteColor
        temperatureLabel.textColor = Colors.primaryTextWhiteColor
    }
    
    func configureUnselectedItem() {
        contentView.backgroundColor = Colors.primaryBackgroundWhiteColor
        timeLabel.textColor = Colors.primaryTextGrayColor
        temperatureLabel.textColor = Colors.primaryTextBlackColor
    }
    
    private func setupCellView() {
        contentView.backgroundColor = Colors.primaryBackgroundWhiteColor
        contentView.layer.cornerRadius = 22
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = Colors.hourlyCvBorderColor.cgColor
    }
    
    private func setupLayout() {
        
        contentView.addSubviews(timeLabel, temperatureLabel, weatherImage)
        
        let constraints = [
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 20),
            weatherImage.heightAnchor.constraint(equalToConstant: 20),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
