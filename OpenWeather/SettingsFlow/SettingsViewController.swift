
import UIKit

class SettingsViewController: UIViewController {

    var coordinator: SettingsCoordinator?
    
    private var storage: StorageService
    
    private let settingsView: SettingsView = {
        let view = SettingsView()
        return view
    }()
    
    init(storage: StorageService = UserDefaultStorage.shared) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                if self.storage.isOnboardingCompleteBoolKey {
                    coordinator.closeSettingsViewController()
                } else {
                    coordinator.pushWeatherViewController()
                    self.storage.isOnboardingCompleteBoolKey = true
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
