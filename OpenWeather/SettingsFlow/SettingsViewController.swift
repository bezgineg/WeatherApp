
import UIKit

class SettingsViewController: UIViewController {

    var coordinator: SettingsCoordinator?
    
    private let settingsView: SettingsView = {
        let view = SettingsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
