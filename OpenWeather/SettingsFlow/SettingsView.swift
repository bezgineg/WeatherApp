
import UIKit

class SettingsView: UIView {
    
    var onSetupButtonTapped: (() -> Void)?
    
    private let settingsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = Colors.settingsViewBackgroundColor
        view.layer.zPosition = 1
        return view
    }()
    
    private let cloudTopImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cloudTop")
        return imageView
    }()
    
    private let cloudMiddleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cloudMiddle")
        return imageView
    }()
    
    private let cloudBottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cloudBottom")
        return imageView
    }()
    
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
        customSwitch.myCustomSwitchSetup()
        customSwitch.labelOn.text = "C"
        customSwitch.labelOff.text = "F"
        customSwitch.addTarget(self, action: #selector(temperatureSwitchChanged(_:)), for: .valueChanged)
        return customSwitch
    }()
    
    private var windSpeedCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.myCustomSwitchSetup()
        customSwitch.labelOn.text = "Km"
        customSwitch.labelOff.text = "Mi"
        customSwitch.addTarget(self, action: #selector(windSpeedSwitchChanged(_:)), for: .valueChanged)
        return customSwitch
    }()
    
    private var timeFormatCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.myCustomSwitchSetup()
        customSwitch.labelOn.text = "24"
        customSwitch.labelOff.text = "12"
        customSwitch.addTarget(self, action: #selector(timeFormatSwitchChanged(_:)), for: .valueChanged)
        return customSwitch
    }()
    
    private var notificationCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
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
        
        backgroundColor = Colors.mainColor
        
        setupSwitchControls()
        setupThumbLabelColor()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSwitchControls() {
        if UserDefaults.standard.bool(forKey: Keys.isOnboardingCompleteBoolKey.rawValue) {
            setupSwitchControlValue(temperatureCustomSwitch, for: Keys.isCelsiusChosenBoolKey.rawValue)
            setupSwitchControlValue(windSpeedCustomSwitch, for: Keys.isKmChosenBoolKey.rawValue)
            setupSwitchControlValue(timeFormatCustomSwitch, for: Keys.is24TimeFormalChosenBoolKey.rawValue)
            setupSwitchControlValue(notificationCustomSwitch, for: Keys.isNotifyBoolKey.rawValue)
        } else {
            temperatureCustomSwitch.isOn = true
            windSpeedCustomSwitch.isOn = true
            timeFormatCustomSwitch.isOn = true
            notificationCustomSwitch.isOn = false
            UserDefaults.standard.setValue(true, forKey: Keys.isCelsiusChosenBoolKey.rawValue)
            UserDefaults.standard.setValue(true, forKey: Keys.isKmChosenBoolKey.rawValue)
            UserDefaults.standard.setValue(true, forKey: Keys.is24TimeFormalChosenBoolKey.rawValue)
            UserDefaults.standard.setValue(false, forKey: Keys.isNotifyBoolKey.rawValue)
        }
    }
    
    private func setupSwitchControlValue(_ switchControl: CustomSwitch, for key: String) {
        let boolValue = UserDefaults.standard.bool(forKey: key)
        if boolValue {
            switchControl.isOn = true
        } else {
            switchControl.isOn = false
        }
    }
    
    private func setupThumbLabelColor() {
        temperatureCustomSwitch.setupLabelColor()
        windSpeedCustomSwitch.setupLabelColor()
        timeFormatCustomSwitch.setupLabelColor()
        notificationCustomSwitch.setupLabelColor()
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
        addSubview(settingsView)
        addSubview(cloudTopImageView)
        addSubview(cloudMiddleImageView)
        addSubview(cloudBottomImageView)
        settingsView.addSubview(settingsLabel)
        settingsView.addSubview(temperatureLabel)
        settingsView.addSubview(windSpeedLabel)
        settingsView.addSubview(timeFormatLabel)
        settingsView.addSubview(notificationLabel)
        settingsView.addSubview(setupButton)
        settingsView.addSubview(temperatureCustomSwitch)
        settingsView.addSubview(windSpeedCustomSwitch)
        settingsView.addSubview(timeFormatCustomSwitch)
        settingsView.addSubview(notificationCustomSwitch)
        
        let constraints = [
            settingsView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            settingsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            settingsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            settingsView.heightAnchor.constraint(equalToConstant: 330),
            
            cloudTopImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            cloudTopImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cloudTopImageView.widthAnchor.constraint(equalToConstant: 250),
            cloudTopImageView.heightAnchor.constraint(equalToConstant: 60),
            
            cloudMiddleImageView.topAnchor.constraint(equalTo: cloudTopImageView.bottomAnchor, constant: 25),
            cloudMiddleImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cloudMiddleImageView.widthAnchor.constraint(equalToConstant: 180),
            cloudMiddleImageView.heightAnchor.constraint(equalToConstant: 95),
            
            cloudBottomImageView.topAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: 80),
            cloudBottomImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cloudBottomImageView.widthAnchor.constraint(equalToConstant: 215),
            cloudBottomImageView.heightAnchor.constraint(equalToConstant: 65),
            
            settingsLabel.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 25),
            settingsLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            
            temperatureLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 20),
            temperatureLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            
            windSpeedLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 25),
            windSpeedLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            
            timeFormatLabel.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 25),
            timeFormatLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            
            notificationLabel.topAnchor.constraint(equalTo: timeFormatLabel.bottomAnchor, constant: 25),
            notificationLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),
            
            setupButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 35),
            setupButton.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -35),
            setupButton.heightAnchor.constraint(equalToConstant: 40),
            setupButton.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -15),
            
            temperatureCustomSwitch.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            temperatureCustomSwitch.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -30),
            temperatureCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            temperatureCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            windSpeedCustomSwitch.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor),
            windSpeedCustomSwitch.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -30),
            windSpeedCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            windSpeedCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            timeFormatCustomSwitch.centerYAnchor.constraint(equalTo: timeFormatLabel.centerYAnchor),
            timeFormatCustomSwitch.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -30),
            timeFormatCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            timeFormatCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            notificationCustomSwitch.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            notificationCustomSwitch.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -30),
            notificationCustomSwitch.widthAnchor.constraint(equalToConstant: 80),
            notificationCustomSwitch.heightAnchor.constraint(equalToConstant: 30),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
