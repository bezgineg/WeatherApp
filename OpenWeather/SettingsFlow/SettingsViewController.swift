
import UIKit

class SettingsViewController: UIViewController {

    var coordinator: SettingsCoordinator?
    
    private let settingsView: SettingsView = {
        let view = SettingsView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        onSetupButtonTapped()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        coordinator?.didFinishSettings()
    }
    
    private func onSetupButtonTapped() {
        if let coordinator = coordinator {
            settingsView.onSetupButtonTapped = {
                if userDefaultStorage.isOnboardingCompleteBoolKey {
                    coordinator.closeSettingsViewController()
                } else {
                    coordinator.pushWeatherViewController()
                    userDefaultStorage.isOnboardingCompleteBoolKey = true
                }
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayout() {
        
        view.addSubviews(settingsView)

        let constraints = [
            settingsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
