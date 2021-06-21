
import UIKit

class PeriodsOfTimeTableViewCell: UITableViewCell {

    private let periodOfTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let feelsImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let feelsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "По ощущениям"
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let feelsTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let firstDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let windImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "скорость ветра")
        return imageView
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Ветер"
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let windInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let secondDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let uvImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sun")
        return imageView
    }()
    
    private let uvLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Уф индекс"
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let uvInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let thirdDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let precipitationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "осадки")
        return imageView
    }()
    
    private let precipitationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Вероятность осадков"
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let precipitationInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let fourthDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let cloudinessImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clouds")
        return imageView
    }()
    
    private let cloudinessLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Облачность"
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    private let cloudinessInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Colors.primaryTextBlackColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.primaryBackgroundWhiteColor
        contentView.layer.cornerRadius = 5
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDay(with object: CachedDaily) {
        contentView.backgroundColor = Colors.customBackgroundColor
        periodOfTimeLabel.text = "День"
        setupWeatherImage(weather: object.weathers.first?.mainEnum.rawValue)
        setupDayTemperature(object)
        descriptionLabel.text = "\(object.weathers.first?.weatherDescriptionEnum.rawValue.capitalizingFirstLetter() ?? "")"
        feelsImage.image = object.feelsLike?.day ?? 0 >= 0 ? UIImage(named: "temp") : UIImage(named: "tempCold")
        windInfoLabel.text = "\(Int(object.windSpeed)) м/с \(Double(object.windDeg).direction.rawValue)"
        uvInfoLabel.text = "\(Int(object.uvi))(\(setupUvLabel(uv: object.uvi)))"
        precipitationInfoLabel.text = "\(Int(object.pop))%"
        cloudinessInfoLabel.text = "\(object.clouds)%"
        setupWindInfoLabel(object)
    }
    
    func configureNight(with object: CachedDaily) {
        contentView.backgroundColor = Colors.customBackgroundColor
        periodOfTimeLabel.text = "Ночь"
        setupWeatherImage(weather: object.weathers.first?.mainEnum.rawValue)
        setupNightTemperature(object)
        descriptionLabel.text = "\(object.weathers.first?.weatherDescriptionEnum.rawValue.capitalizingFirstLetter() ?? "")"
        feelsImage.image = object.feelsLike?.day ?? 0 >= 0 ? UIImage(named: "temp") : UIImage(named: "tempCold")
        uvInfoLabel.text = "\(Int(object.uvi))(\(setupUvLabel(uv: object.uvi)))"
        precipitationInfoLabel.text = "\(Int(object.pop))%"
        cloudinessInfoLabel.text = "\(object.clouds)%"
        setupWindInfoLabel(object)
    }
    
    private func setupWindInfoLabel(_ object: CachedDaily) {
        if UserDefaults.standard.bool(forKey: Keys.isKmChosenBoolKey.rawValue) {
            windInfoLabel.text = "\(Int(object.windSpeed)) м/с \(Double(object.windDeg).direction.rawValue)"
        } else {
            windInfoLabel.text = "\(Int(object.windSpeed * 2.23694)) ми/ч \(Double(object.windDeg).direction.rawValue)"
        }
    }
    
    private func setupDayTemperature(_ object: CachedDaily) {
        if UserDefaults.standard.bool(forKey: Keys.isCelsiusChosenBoolKey.rawValue) {
            temperatureLabel.text = "\(Int(object.temp?.day ?? 0))°"
            feelsTempLabel.text = "\(Int(object.feelsLike?.day ?? 0))°"
        } else {
            temperatureLabel.text = "\(fahrenheitConversion(object.temp?.day ?? 0))°"
            feelsTempLabel.text = "\(fahrenheitConversion(object.feelsLike?.day ?? 0))°"
        }
    }
    
    private func setupNightTemperature(_ object: CachedDaily) {
        if UserDefaults.standard.bool(forKey: Keys.isCelsiusChosenBoolKey.rawValue) {
            temperatureLabel.text = "\(Int(object.temp?.night ?? 0))°"
            feelsTempLabel.text = "\(Int(object.feelsLike?.night ?? 0))°"
        } else {
            temperatureLabel.text = "\(fahrenheitConversion(object.temp?.night ?? 0))°"
            feelsTempLabel.text = "\(fahrenheitConversion(object.feelsLike?.night ?? 0))°"
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
    
    private func setupUvLabel(uv: Double) -> String {
        switch uv {
        case ..<3:
            return "низкий"
        case 3..<6:
            return "средний"
        case 6..<8:
            return "высокий"
        case 8..<11:
            return "очень высокий"
        case 11...:
            return "экстремальный"
        default:
            return ""
        }
    }
    
    private func setupLayout() {
        
        contentView.addSubviews(periodOfTimeLabel, weatherImage, temperatureLabel, descriptionLabel, feelsImage, feelsLabel, feelsTempLabel,firstDividerView, windImage, windLabel, windInfoLabel, secondDividerView, uvImage, uvLabel, uvInfoLabel, thirdDividerView, precipitationImage, precipitationLabel, precipitationInfoLabel, fourthDividerView, cloudinessImage, cloudinessLabel, cloudinessInfoLabel)
        
        let constraints = [
            periodOfTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            periodOfTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            weatherImage.leadingAnchor.constraint(equalTo: periodOfTimeLabel.trailingAnchor, constant: 75),
            weatherImage.widthAnchor.constraint(equalToConstant: 26),
            weatherImage.heightAnchor.constraint(equalToConstant: 32),
            
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 10),
            
            descriptionLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            feelsImage.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            feelsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            feelsImage.widthAnchor.constraint(equalToConstant: 24),
            feelsImage.heightAnchor.constraint(equalToConstant: 26),
            
            feelsLabel.centerYAnchor.constraint(equalTo: feelsImage.centerYAnchor),
            feelsLabel.leadingAnchor.constraint(equalTo: feelsImage.trailingAnchor, constant: 15),
            
            feelsTempLabel.centerYAnchor.constraint(equalTo: feelsImage.centerYAnchor),
            feelsTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            firstDividerView.topAnchor.constraint(equalTo: feelsImage.bottomAnchor, constant: 14),
            firstDividerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            firstDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            windImage.topAnchor.constraint(equalTo: firstDividerView.bottomAnchor, constant: 15),
            windImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            windImage.widthAnchor.constraint(equalToConstant: 24),
            windImage.heightAnchor.constraint(equalToConstant: 26),
            
            windLabel.centerYAnchor.constraint(equalTo: windImage.centerYAnchor),
            windLabel.leadingAnchor.constraint(equalTo: windImage.trailingAnchor, constant: 15),
            
            windInfoLabel.centerYAnchor.constraint(equalTo: windImage.centerYAnchor),
            windInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            secondDividerView.topAnchor.constraint(equalTo: windImage.bottomAnchor, constant: 14),
            secondDividerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            secondDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            uvImage.topAnchor.constraint(equalTo: secondDividerView.bottomAnchor, constant: 15),
            uvImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            uvImage.widthAnchor.constraint(equalToConstant: 24),
            uvImage.heightAnchor.constraint(equalToConstant: 26),
            
            uvLabel.centerYAnchor.constraint(equalTo: uvImage.centerYAnchor),
            uvLabel.leadingAnchor.constraint(equalTo: uvImage.trailingAnchor, constant: 15),
            
            uvInfoLabel.centerYAnchor.constraint(equalTo: uvImage.centerYAnchor),
            uvInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            thirdDividerView.topAnchor.constraint(equalTo: uvImage.bottomAnchor, constant: 14),
            thirdDividerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            thirdDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            precipitationImage.topAnchor.constraint(equalTo: thirdDividerView.bottomAnchor, constant: 15),
            precipitationImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            precipitationImage.widthAnchor.constraint(equalToConstant: 24),
            precipitationImage.heightAnchor.constraint(equalToConstant: 26),
            
            precipitationLabel.centerYAnchor.constraint(equalTo: precipitationImage.centerYAnchor),
            precipitationLabel.leadingAnchor.constraint(equalTo: precipitationImage.trailingAnchor, constant: 15),
            
            precipitationInfoLabel.centerYAnchor.constraint(equalTo: precipitationImage.centerYAnchor),
            precipitationInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            fourthDividerView.topAnchor.constraint(equalTo: precipitationImage.bottomAnchor, constant: 14),
            fourthDividerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            fourthDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            cloudinessImage.topAnchor.constraint(equalTo: fourthDividerView.bottomAnchor, constant: 15),
            cloudinessImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cloudinessImage.widthAnchor.constraint(equalToConstant: 24),
            cloudinessImage.heightAnchor.constraint(equalToConstant: 26),
            
            cloudinessLabel.centerYAnchor.constraint(equalTo: cloudinessImage.centerYAnchor),
            cloudinessLabel.leadingAnchor.constraint(equalTo: cloudinessImage.trailingAnchor, constant: 15),
            
            cloudinessInfoLabel.centerYAnchor.constraint(equalTo: cloudinessImage.centerYAnchor),
            cloudinessInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cloudinessInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
