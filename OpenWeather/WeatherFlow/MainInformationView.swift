import UIKit

class MainInformationView: UIView {
    
    var storage: StorageService?
    
    private let arcImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arc")
        return imageView
    }()
    
    private let dailyTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let cloudyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "облачность")
        return imageView
    }()
    
    private let cloudyLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let windSpeedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "скорость ветра")
        return imageView
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let humidityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "осадки")
        return imageView
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let sunriseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "восход")?.withTintColor(Colors.imageTintYellowColor)
        return imageView
    }()
    
    private let sunriseLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let sunsetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "закат")?.withTintColor(Colors.imageTintYellowColor)
        return imageView
    }()
    
    private let sunsetLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextWhiteColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextYellowColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    init(storage: StorageService = UserDefaultStorage.shared) {
        super.init(frame: .zero)
        self.storage = storage
        backgroundColor = Colors.mainColor
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: CityWeather) {
        descriptionLabel.text = "\(object.current.weather.first?.weatherDescription.rawValue ?? "")".capitalizingFirstLetter()
        cloudyLabel.text = "\(object.current.clouds)"
        humidityLabel.text = "\(object.current.humidity)%"
        setupTemperature(with: object)
        setupDate()
        setupWindSpeed(with: object)
        setupSunriseAndSunsetDate(
            sunrise: object.current.sunrise ?? 0,
            sunset: object.current.sunset ?? 0
        )
    }
    
    func setupTemperature(with object: CityWeather) {
        guard let storage = storage else { return }
        if storage.isCelsiusChosenBoolKey {
            dailyTemperatureLabel.text = "\(Int(object.daily.first?.temp.min ?? 0))°/ \(Int(object.daily.first?.temp.max ?? 0))°"
            currentTemperatureLabel.text = "\(Int(object.current.temp))°"
        } else {
            let dailyTempMin = fahrenheitConversion(object.daily.first?.temp.min ?? 0)
            let dailyTempMax = fahrenheitConversion(object.daily.first?.temp.max ?? 0)
            dailyTemperatureLabel.text = "\(dailyTempMin)°/\(dailyTempMax)°"
            let currentTemp = fahrenheitConversion(object.current.temp)
            currentTemperatureLabel.text = "\(currentTemp)°"
        }
    }
    
    func setupWindSpeed(with object: CityWeather) {
        guard let storage = storage else { return }
        if storage.isKmChosenBoolKey {
            windSpeedLabel.text = "\(Int(object.current.windSpeed)) м/c"
        } else {
            windSpeedLabel.text = "\(Int((object.current.windSpeed)*2.23694)) ми/ч"
        }
    }
    
    func setupSunriseAndSunsetDate(sunrise: Int, sunset: Int) {
        guard let storage = storage else { return }
        let sunriseDate = NSDate(timeIntervalSince1970: TimeInterval(sunrise))
        let sunsetDate = NSDate(timeIntervalSince1970: TimeInterval(sunset))
        let formatter = DateFormatter()
        if storage.is24TimeFormalChosenBoolKey {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "h:mm a"
        }
        sunriseLabel.text = formatter.string(from: sunriseDate as Date)
        sunsetLabel.text = formatter.string(from: sunsetDate as Date)
    }
    
   func setupDate() {
    guard let storage = storage else { return }
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
    if storage.is24TimeFormalChosenBoolKey {
            formatter.dateFormat = "HH:mm, E d MMM"
        } else {
            formatter.dateFormat = "h:mm a, E d MMM"
        }
        dateLabel.text = formatter.string(from: date)
    }
    
    func update(with object: Current) {
        guard let storage = storage else { return }
        currentTemperatureLabel.text = "\(Int(object.temp))°"
        descriptionLabel.text = "\(object.weather.first?.weatherDescription.rawValue ?? "")".capitalizingFirstLetter()
        cloudyLabel.text = "\(object.clouds)"
        humidityLabel.text = "\(object.humidity)%"
        if storage.isKmChosenBoolKey {
            windSpeedLabel.text = "\(Int(object.windSpeed)) м/с"
        } else {
            windSpeedLabel.text = "\(Int(object.windSpeed*2.23694)) ми/ч"
        }
        
        if storage.isCelsiusChosenBoolKey {
            currentTemperatureLabel.text = "\(Int(object.temp))°"
        } else {
            let currentTemp = fahrenheitConversion(object.temp)
            currentTemperatureLabel.text = "\(currentTemp)°"
        }
    }
    
    private func setupLayout() {
        
        addSubviews(arcImageView, dailyTemperatureLabel, currentTemperatureLabel, descriptionLabel, cloudyImage, cloudyLabel, windSpeedImage, windSpeedLabel, humidityImage, humidityLabel, sunriseImage, sunriseLabel, sunsetImage, sunsetLabel, dateLabel)
        
        let constraints = [
            
            arcImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            arcImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 31),
            arcImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -31),
            arcImageView.heightAnchor.constraint(equalToConstant: 123),
            
            dailyTemperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            dailyTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            currentTemperatureLabel.topAnchor.constraint(equalTo: dailyTemperatureLabel.bottomAnchor, constant: 5),
            currentTemperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cloudyImage.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            cloudyImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 75),
            cloudyImage.widthAnchor.constraint(equalToConstant: 21),
            cloudyImage.heightAnchor.constraint(equalToConstant: 18),
            
            cloudyLabel.centerYAnchor.constraint(equalTo: cloudyImage.centerYAnchor),
            cloudyLabel.leadingAnchor.constraint(equalTo: cloudyImage.trailingAnchor, constant: 5),
            
            windSpeedImage.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            windSpeedImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 130),
            windSpeedImage.widthAnchor.constraint(equalToConstant: 25),
            windSpeedImage.heightAnchor.constraint(equalToConstant: 16),
            
            windSpeedLabel.centerYAnchor.constraint(equalTo: windSpeedImage.centerYAnchor),
            windSpeedLabel.leadingAnchor.constraint(equalTo: windSpeedImage.trailingAnchor, constant: 5),
            
            humidityImage.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            humidityImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 215),
            humidityImage.widthAnchor.constraint(equalToConstant: 13),
            humidityImage.heightAnchor.constraint(equalToConstant: 15),
            
            humidityLabel.centerYAnchor.constraint(equalTo: humidityImage.centerYAnchor),
            humidityLabel.leadingAnchor.constraint(equalTo: humidityImage.trailingAnchor, constant: 5),
            
            sunriseImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            sunriseImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            sunriseImage.widthAnchor.constraint(equalToConstant: 17),
            sunriseImage.heightAnchor.constraint(equalToConstant: 17),
            
            sunriseLabel.topAnchor.constraint(equalTo: sunriseImage.bottomAnchor, constant: 5),
            sunriseLabel.centerXAnchor.constraint(equalTo: sunriseImage.centerXAnchor),
            
            sunsetImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            sunsetImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            sunsetImage.widthAnchor.constraint(equalToConstant: 17),
            sunsetImage.heightAnchor.constraint(equalToConstant: 17),
            
            sunsetLabel.topAnchor.constraint(equalTo: sunsetImage.bottomAnchor, constant: 5),
            sunsetLabel.centerXAnchor.constraint(equalTo: sunsetImage.centerXAnchor),
            
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

}

