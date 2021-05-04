
import UIKit

class SettingsView: UIView {
    
    var onSetupButtonTapped: (() -> Void)?
    
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Настройки"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Температура"
        label.setupLabel()
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Скорость ветра"
        label.setupLabel()
        return label
    }()
    
    private let timeFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "Формат времени"
        label.setupLabel()
        return label
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Уведомления"
        label.setupLabel()
        return label
    }()
    
    private var temperatureCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.isOn = true
        customSwitch.myCustomSwitchSetup()
        customSwitch.labelOn.text = "C"
        customSwitch.labelOff.text = "F"
        customSwitch.addTarget(self, action: #selector(temperatureSwitchChanged(_:)), for: .valueChanged)
        return customSwitch
    }()
    
    private var windSpeedCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.isOn = true
        customSwitch.myCustomSwitchSetup()
        customSwitch.labelOn.text = "Km"
        customSwitch.labelOff.text = "Mi"
        customSwitch.addTarget(self, action: #selector(windSpeedSwitchChanged(_:)), for: .valueChanged)
        return customSwitch
    }()
    
    private var timeFormatCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.isOn = true
        customSwitch.myCustomSwitchSetup()
        customSwitch.labelOn.text = "24"
        customSwitch.labelOff.text = "12"
        customSwitch.addTarget(self, action: #selector(timeFormatSwitchChanged(_:)), for: .valueChanged)
        return customSwitch
    }()
    
    private var notificationCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.isOn = false
        customSwitch.myCustomSwitchSetup()
        customSwitch.labelOn.text = "On"
        customSwitch.labelOff.text = "Off"
        customSwitch.addTarget(self, action: #selector(notificationSwitchChanged(_:)), for: .valueChanged)
        return customSwitch
    }()
    
    private lazy var setupButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Установить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = Colors.buttonColor
        button.setBackgroundColor(Colors.buttonSelectedColor, forState: .selected)
        button.setBackgroundColor(Colors.buttonSelectedColor, forState: .highlighted)
        button.addTarget(self, action: #selector(setupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.settingsViewBackgroundColor
        
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func temperatureSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: Keys.isCelsiusChosenBoolKey.rawValue)
        } else {
            UserDefaults.standard.setValue(false, forKey: Keys.isCelsiusChosenBoolKey.rawValue)
        }
    }
    
    @objc private func windSpeedSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: Keys.isKmChosenBoolKey.rawValue)
        } else {
            UserDefaults.standard.setValue(false, forKey: Keys.isKmChosenBoolKey.rawValue)
        }
    }
    
    @objc private func timeFormatSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: Keys.is24TimeFormalChosenBoolKey.rawValue)
        } else {
            UserDefaults.standard.setValue(false, forKey: Keys.is24TimeFormalChosenBoolKey.rawValue)
        }
    }
    
    @objc private func notificationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: Keys.isNotifyBoolKey.rawValue)
        } else {
            UserDefaults.standard.setValue(false, forKey: Keys.isNotifyBoolKey.rawValue)
        }
    }
    
    @objc private func setupButtonTapped() {
        onSetupButtonTapped?()
    }
    
    private func setupLayout() {
        addSubview(settingsLabel)
        addSubview(temperatureLabel)
        addSubview(windSpeedLabel)
        addSubview(timeFormatLabel)
        addSubview(notificationLabel)
        addSubview(setupButton)
        addSubview(temperatureCustomSwitch)
        addSubview(windSpeedCustomSwitch)
        addSubview(timeFormatCustomSwitch)
        addSubview(notificationCustomSwitch)
        
        let constraints = [
            settingsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            settingsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            temperatureLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            windSpeedLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 25),
            windSpeedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            timeFormatLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 25),
            timeFormatLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            notificationLabel.topAnchor.constraint(equalTo: timeFormatLabel.bottomAnchor, constant: 25),
            notificationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            setupButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            setupButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35),
            setupButton.heightAnchor.constraint(equalToConstant: 40),
            setupButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            temperatureCustomSwitch.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            temperatureCustomSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            temperatureCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            temperatureCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            windSpeedCustomSwitch.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor),
            windSpeedCustomSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            windSpeedCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            windSpeedCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            timeFormatCustomSwitch.centerYAnchor.constraint(equalTo: timeFormatLabel.centerYAnchor),
            timeFormatCustomSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            timeFormatCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            timeFormatCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            notificationCustomSwitch.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            notificationCustomSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            notificationCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            notificationCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
