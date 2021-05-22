
import UIKit

class DetailsTableViewCell: UITableViewCell {

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let feelsTemperatureImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let feelsTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "По ощущению"
        return label
    }()
    
    private let feelsTemperatureInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let windImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "скорость ветра")
        return imageView
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "Ветер"
        return label
    }()
    
    private let windInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let precipitationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "осадки")
        return imageView
    }()
    
    private let precipitationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "Вероятность осадков"
        return label
    }()
    
    private let precipitationInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let cloudsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clouds")
        return imageView
    }()
    
    private let cloudsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "Облачность"
        return label
    }()
   
    private let cloudsInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        contentView.backgroundColor = Colors.customBackgroundColor
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: CachedCurrent) {
        setupDayLabel(day: object.dt)
        setupTimeLabel(time: object.dt)
        feelsTemperatureImage.image = object.feelsLike >= 0 ? UIImage(named: "temp") : UIImage(named: "tempCold")
        setupTemperature(object)
        setupWindInfoLabel(object)
        precipitationInfoLabel.text = "\(Int((object.pop) * 100))%"
        cloudsInfoLabel.text = "\(object.clouds)%"
    }
    
    private func setupTemperature(_ object: CachedCurrent) {
        if UserDefaults.standard.bool(forKey: Keys.isCelsiusChosenBoolKey.rawValue) {
            temperatureLabel.text = "\(Int(object.temp))°"
            feelsTemperatureInfoLabel.text = "\(Int(object.feelsLike))°"
        } else {
            temperatureLabel.text = "\(fahrenheitConversion(object.temp))°"
            feelsTemperatureInfoLabel.text = "\(fahrenheitConversion(object.feelsLike))°"
        }
    }
    
    private func setupWindInfoLabel(_ object: CachedCurrent) {
        if UserDefaults.standard.bool(forKey: Keys.isKmChosenBoolKey.rawValue) {
            windInfoLabel.text = "\(Int(object.windSpeed)) м/с \(Double(object.windDeg).direction)"
        } else {
            windInfoLabel.text = "\(Int(object.windSpeed * 2.23694)) ми/ч \(Double(object.windDeg).direction)"
        }
    }
    
    private func setupDayLabel(day: Int) {
        let date = NSDate(timeIntervalSince1970: TimeInterval(day))
        let formatter = DateFormatter()
        formatter.dateFormat = "E dd/MM"
        formatter.locale = Locale(identifier: "ru_RU")
        dayLabel.text = formatter.string(from: date as Date).lowercased()
    }
    
    private func setupTimeLabel(time: Int) {
        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        if UserDefaults.standard.bool(forKey: Keys.is24TimeFormalChosenBoolKey.rawValue) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "h:mm a"
        }
        timeLabel.text = formatter.string(from: date as Date)
    }
    
    private func setupLayout() {

        contentView.addSubviews(dayLabel, timeLabel, temperatureLabel, feelsTemperatureImage, feelsTemperatureLabel, feelsTemperatureInfoLabel, windImage, windLabel, windInfoLabel, precipitationImage, precipitationLabel, precipitationInfoLabel, cloudsImage, cloudsLabel, cloudsInfoLabel)
        
        let constraints = [
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            timeLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            temperatureLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor),
            
            feelsTemperatureImage.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            feelsTemperatureImage.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            feelsTemperatureImage.widthAnchor.constraint(equalToConstant: 12),
            feelsTemperatureImage.heightAnchor.constraint(equalToConstant: 12),
            
            feelsTemperatureLabel.centerYAnchor.constraint(equalTo: feelsTemperatureImage.centerYAnchor),
            feelsTemperatureLabel.leadingAnchor.constraint(equalTo: feelsTemperatureImage.trailingAnchor, constant: 5),
            
            feelsTemperatureInfoLabel.centerYAnchor.constraint(equalTo: feelsTemperatureLabel.centerYAnchor),
            feelsTemperatureInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            windImage.centerXAnchor.constraint(equalTo: feelsTemperatureImage.centerXAnchor),
            windImage.topAnchor.constraint(equalTo: feelsTemperatureImage.bottomAnchor, constant: 10),
            windImage.widthAnchor.constraint(equalToConstant: 15),
            windImage.heightAnchor.constraint(equalToConstant: 10),
            
            windLabel.centerYAnchor.constraint(equalTo: windImage.centerYAnchor),
            windLabel.leadingAnchor.constraint(equalTo: windImage.trailingAnchor, constant: 2),
            
            windInfoLabel.centerYAnchor.constraint(equalTo: windLabel.centerYAnchor),
            windInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            precipitationImage.centerXAnchor.constraint(equalTo: feelsTemperatureImage.centerXAnchor),
            precipitationImage.topAnchor.constraint(equalTo: windImage.bottomAnchor, constant: 10),
            precipitationImage.widthAnchor.constraint(equalToConstant: 11),
            precipitationImage.heightAnchor.constraint(equalToConstant: 13),
            
            precipitationLabel.centerYAnchor.constraint(equalTo: precipitationImage.centerYAnchor),
            precipitationLabel.leadingAnchor.constraint(equalTo: precipitationImage.trailingAnchor, constant: 6),
            
            precipitationInfoLabel.centerYAnchor.constraint(equalTo: precipitationLabel.centerYAnchor),
            precipitationInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            cloudsImage.centerXAnchor.constraint(equalTo: feelsTemperatureImage.centerXAnchor),
            cloudsImage.topAnchor.constraint(equalTo: precipitationImage.bottomAnchor, constant: 10),
            cloudsImage.widthAnchor.constraint(equalToConstant: 14),
            cloudsImage.heightAnchor.constraint(equalToConstant: 10),
            
            cloudsLabel.centerYAnchor.constraint(equalTo: cloudsImage.centerYAnchor),
            cloudsLabel.leadingAnchor.constraint(equalTo: cloudsImage.trailingAnchor, constant: 3),
            cloudsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
             
            cloudsInfoLabel.centerYAnchor.constraint(equalTo: cloudsLabel.centerYAnchor),
            cloudsInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
