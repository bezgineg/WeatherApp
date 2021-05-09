import UIKit

class MainInformationView: UIView {
    
    private let dailyTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let cloudyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "облачность")
        return imageView
    }()
    
    private let cloudyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let windSpeedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "скорость ветра")
        return imageView
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let humidityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "осадки")
        return imageView
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let sunriseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "восход")?.withTintColor(.yellow)
        return imageView
    }()
    
    private let sunriseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let sunsetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "закат")?.withTintColor(.yellow)
        return imageView
    }()
    
    private let sunsetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yellow
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.mainColor
        drawArc()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with object: WeatherData) {
        dailyTemperatureLabel.text = "\(Int(object.daily.first?.temp.min ?? 0))°/ \(Int(object.daily.first?.temp.max ?? 0))°"
        currentTemperatureLabel.text = "\(Int(object.current.temp))°"
        descriptionLabel.text = "\(object.current.weather.first?.weatherDescription.rawValue ?? "")".capitalizingFirstLetter()
        cloudyLabel.text = "\(object.current.clouds)"
        windSpeedLabel.text = "\(Int(object.current.windSpeed)) м/с"
        humidityLabel.text = "\(object.current.humidity)%"
        setupDate()
        setupSunriseAndSunsetDate(sunrise: object.current.sunrise ?? 0, sunset: object.current.sunset ?? 0)
    }
    
    private func setupSunriseAndSunsetDate(sunrise: Int, sunset: Int) {
        let sunriseDate = NSDate(timeIntervalSince1970: TimeInterval(sunrise))
        let sunsetDate = NSDate(timeIntervalSince1970: TimeInterval(sunset))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        sunriseLabel.text = formatter.string(from: sunriseDate as Date)
        sunsetLabel.text = formatter.string(from: sunsetDate as Date)
    }
    
    private func setupDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, E d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = formatter.string(from: date)
    }
    
    private func drawArc() {
        let path = UIBezierPath(arcCenter: CGPoint(x: 173, y: 160), radius: 140, startAngle: 0, endAngle: .pi, clockwise: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor =  UIColor.yellow.cgColor
        shapeLayer.fillColor = Colors.mainColor.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
    
    private func setupLayout() {

        addSubview(currentTemperatureLabel)
        addSubview(dailyTemperatureLabel)
        addSubview(descriptionLabel)
        addSubview(cloudyImage)
        addSubview(cloudyLabel)
        addSubview(windSpeedImage)
        addSubview(windSpeedLabel)
        addSubview(humidityImage)
        addSubview(humidityLabel)
        addSubview(sunriseImage)
        addSubview(sunriseLabel)
        addSubview(sunsetImage)
        addSubview(sunsetLabel)
        addSubview(dateLabel)
        
        let constraints = [
            
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
            sunriseImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            sunriseImage.widthAnchor.constraint(equalToConstant: 17),
            sunriseImage.heightAnchor.constraint(equalToConstant: 17),
            
            sunriseLabel.topAnchor.constraint(equalTo: sunriseImage.bottomAnchor, constant: 5),
            sunriseLabel.centerXAnchor.constraint(equalTo: sunriseImage.centerXAnchor),
            
            sunsetImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            sunsetImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -33),
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

