
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
    
    private let sunImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sun")
        return imageView
    }()
    
    private let dayDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let verticalDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let moonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moon")
        return imageView
    }()
    
    private let nightDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let firstDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let daySunriseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = "Восход"
        return label
    }()
    
    private let daySunriseTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let secondDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let daySunsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = "Заход"
        return label
    }()
    
    private let daySunsetTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let thirdDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let nightMoonriseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = "Восход"
        return label
    }()
    
    private let nightMoonriseTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let fourthDividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = Colors.dividerColor
        return divider
    }()
    
    private let nightMoonsetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = "Заход"
        return label
    }()
    
    private let nightMoonsetTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
    
    func configure(with object: CachedDaily) {
        contentView.backgroundColor = .white
        setupMoonPhase(moonphase: object.moonPhase)
        setupDayDurationLabel(sunrise: object.sunrise, sunset: object.sunset)
        setupNightDurationLabel(moonrise: object.moonrise, moonset: object.moonset)
        setupSunriseAndSunsetTime(sunrise: object.sunrise, sunset: object.sunset)
        setupMoonriseAndMoonsetTime(moonrise: object.moonrise, moonset: object.moonset)
    }
    
    private func setupSunriseAndSunsetTime(sunrise: Int, sunset: Int) {
        let sunriseDate = NSDate(timeIntervalSince1970: TimeInterval(sunrise))
        let sunsetDate = NSDate(timeIntervalSince1970: TimeInterval(sunset))
        let formatter = DateFormatter()
        if UserDefaults.standard.bool(forKey: Keys.is24TimeFormalChosenBoolKey.rawValue) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "h:mm a"
        }
        daySunriseTimeLabel.text = formatter.string(from: sunriseDate as Date)
        daySunsetTimeLabel.text = formatter.string(from: sunsetDate as Date)
    }
    
    private func setupMoonriseAndMoonsetTime(moonrise: Int, moonset: Int) {
        let moonriseDate = NSDate(timeIntervalSince1970: TimeInterval(moonrise))
        let moonsetDate = NSDate(timeIntervalSince1970: TimeInterval(moonset))
        let formatter = DateFormatter()
        if UserDefaults.standard.bool(forKey: Keys.is24TimeFormalChosenBoolKey.rawValue) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "h:mm a"
        }
        nightMoonriseTimeLabel.text = formatter.string(from: moonsetDate as Date)
        nightMoonsetTimeLabel.text = formatter.string(from: moonriseDate as Date)
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
    
    private func setupDayDurationLabel(sunrise: Int, sunset: Int) {
        let duration = sunset - sunrise
        let date = NSDate(timeIntervalSince1970: TimeInterval(duration))
        let hourFormatter = DateFormatter()
        let minuteFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        minuteFormatter.dateFormat = "mm"
        dayDurationLabel.text = "\(hourFormatter.string(from: date as Date))ч \(minuteFormatter.string(from: date as Date)) мин"
    }
    
    private func setupNightDurationLabel(moonrise: Int, moonset: Int) {
        let duration = moonrise - moonset
        let date = NSDate(timeIntervalSince1970: TimeInterval(duration))
        let hourFormatter = DateFormatter()
        let minuteFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        minuteFormatter.dateFormat = "mm"
        nightDurationLabel.text = "\(hourFormatter.string(from: date as Date))ч \(minuteFormatter.string(from: date as Date)) мин"
    }
    
    private func setupLayout() {
        
        contentView.addSubviews(mainLabel, moonPhaseLabel, moonPhaseImage, sunImage, verticalDividerView, dayDurationLabel, moonImage, nightDurationLabel, firstDividerView, secondDividerView, thirdDividerView, fourthDividerView, daySunriseLabel, daySunsetLabel, nightMoonriseLabel, nightMoonsetLabel, daySunriseTimeLabel, daySunsetTimeLabel, nightMoonriseTimeLabel, nightMoonsetTimeLabel)
        
        let constraints = [
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            moonPhaseLabel.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
            moonPhaseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            moonPhaseImage.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor),
            moonPhaseImage.trailingAnchor.constraint(equalTo: moonPhaseLabel.leadingAnchor, constant: -5),
            moonPhaseImage.widthAnchor.constraint(equalToConstant: 15),
            moonPhaseImage.heightAnchor.constraint(equalToConstant: 15),
            
            sunImage.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 15),
            sunImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sunImage.widthAnchor.constraint(equalToConstant: 20),
            sunImage.heightAnchor.constraint(equalToConstant: 23),
            
            verticalDividerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            verticalDividerView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 15),
            verticalDividerView.widthAnchor.constraint(equalToConstant: 0.5),
            verticalDividerView.heightAnchor.constraint(equalToConstant: 100),
            verticalDividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            dayDurationLabel.centerYAnchor.constraint(equalTo: sunImage.centerYAnchor),
            dayDurationLabel.trailingAnchor.constraint(equalTo: verticalDividerView.leadingAnchor, constant: -15),
            
            moonImage.centerYAnchor.constraint(equalTo: sunImage.centerYAnchor),
            moonImage.leadingAnchor.constraint(equalTo: verticalDividerView.trailingAnchor, constant: 30),
            moonImage.widthAnchor.constraint(equalToConstant: 20),
            moonImage.heightAnchor.constraint(equalToConstant: 20),
            
            nightDurationLabel.centerYAnchor.constraint(equalTo: moonImage.centerYAnchor),
            nightDurationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            firstDividerView.topAnchor.constraint(equalTo: sunImage.bottomAnchor, constant: 10),
            firstDividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstDividerView.trailingAnchor.constraint(equalTo: verticalDividerView.leadingAnchor, constant: -10),
            firstDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            daySunriseLabel.topAnchor.constraint(equalTo: firstDividerView.bottomAnchor, constant:10),
            daySunriseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            daySunriseTimeLabel.centerYAnchor.constraint(equalTo: daySunriseLabel.centerYAnchor),
            daySunriseTimeLabel.trailingAnchor.constraint(equalTo: verticalDividerView.leadingAnchor, constant: -15),
            
            secondDividerView.topAnchor.constraint(equalTo: daySunriseLabel.bottomAnchor, constant: 10),
            secondDividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            secondDividerView.trailingAnchor.constraint(equalTo: verticalDividerView.leadingAnchor, constant: -10),
            secondDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            daySunsetLabel.topAnchor.constraint(equalTo: secondDividerView.bottomAnchor, constant:10),
            daySunsetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            daySunsetTimeLabel.centerYAnchor.constraint(equalTo: daySunsetLabel.centerYAnchor),
            daySunsetTimeLabel.trailingAnchor.constraint(equalTo: verticalDividerView.leadingAnchor, constant: -15),
            
            thirdDividerView.centerYAnchor.constraint(equalTo: firstDividerView.centerYAnchor),
            thirdDividerView.leadingAnchor.constraint(equalTo: verticalDividerView.trailingAnchor, constant: 10),
            thirdDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thirdDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            nightMoonriseLabel.centerYAnchor.constraint(equalTo: daySunriseLabel.centerYAnchor),
            nightMoonriseLabel.leadingAnchor.constraint(equalTo: verticalDividerView.trailingAnchor, constant: 25),
            
            nightMoonriseTimeLabel.centerYAnchor.constraint(equalTo: nightMoonriseLabel.centerYAnchor),
            nightMoonriseTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            fourthDividerView.centerYAnchor.constraint(equalTo: secondDividerView.centerYAnchor),
            fourthDividerView.leadingAnchor.constraint(equalTo: verticalDividerView.trailingAnchor, constant: 10),
            fourthDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fourthDividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            nightMoonsetLabel.centerYAnchor.constraint(equalTo: daySunsetLabel.centerYAnchor),
            nightMoonsetLabel.leadingAnchor.constraint(equalTo: verticalDividerView.leadingAnchor, constant: 25),
            
            nightMoonsetTimeLabel.centerYAnchor.constraint(equalTo: nightMoonsetLabel.centerYAnchor),
            nightMoonsetTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
