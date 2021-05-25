
import UIKit

class OnboardingView: UIView {
    
    var onAcceptButtonTap: (() -> Void)?
    var onDeclineButtonTap: (() -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image")
        return imageView
    }()
    
    private let permissionLabel: UILabel = {
        let label = UILabel()
        label.text = "Разрешить приложению  Weather \nиспользовать данные \nо местоположении вашего устройства"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = "Чтобы получить более точные прогнозы погоды во время движения или путешествия \n \nВы можете изменить свой выбор в любое время из меню приложения"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 5
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitle("ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ  УСТРОЙСТВА", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.backgroundColor = Colors.buttonColor
        button.setBackgroundColor(Colors.buttonSelectedColor, forState: .selected)
        button.setBackgroundColor(Colors.buttonSelectedColor, forState: .highlighted)
        button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var declineButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 0.0)
        button.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.mainColor
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func acceptButtonTapped() {
        onAcceptButtonTap?()
    }
    
    @objc func declineButtonTapped() {
        onDeclineButtonTap?()
    }
    
    private func setupLayout() {
        
        addSubviews(imageView, permissionLabel, explanationLabel, acceptButton, declineButton)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35),
            imageView.heightAnchor.constraint(equalToConstant: 330),
            
            permissionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            permissionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            permissionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            explanationLabel.topAnchor.constraint(equalTo: permissionLabel.bottomAnchor, constant: 30),
            explanationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            explanationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            acceptButton.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 40),
            acceptButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            acceptButton.heightAnchor.constraint(equalToConstant: 40),
            
            declineButton.topAnchor.constraint(equalTo: acceptButton.bottomAnchor, constant: 25),
            declineButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            declineButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            declineButton.heightAnchor.constraint(equalToConstant: 40),
            declineButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
