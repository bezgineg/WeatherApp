
import UIKit

class SettingsViewController: UIViewController {

    var coordinator: SettingsCoordinator?
    
    private let settingsView: SettingsView = {
        let view = SettingsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.mainColor
        
        setupLayout()
        onSetupButtonTapped()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.didFinishSettings()
    }
    
    private func onSetupButtonTapped() {
        if let settingsCoordinator = coordinator {
            settingsView.onSetupButtonTapped = {
                settingsCoordinator.pushWeatherViewController()
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(settingsView)

        let constraints = [
            settingsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsView.heightAnchor.constraint(equalToConstant: 330)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
