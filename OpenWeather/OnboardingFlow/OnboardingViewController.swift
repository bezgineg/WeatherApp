
import UIKit

class OnboardingViewController: UIViewController {
    
    var coordinator: OnboardingCoordinator?
    
    let weatherDataProvider: WeatherDataProvider
    
    private let onboardingView: OnboardingView = {
        let view = OnboardingView()
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    init(weatherDataProvider: WeatherDataProvider) {
        self.weatherDataProvider = weatherDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.mainColor
        
        setupNotifications()
        setupNavigationBar()
        setupLayout()
        onAcceptButtonTapSetup()
        onDeclineButtonTapSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.didFinishOnboarding()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(openNextViewController), name: Notification.Name("openNextViewController"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: Notification.Name("showAlert"), object: nil)
    }
    
    private func onAcceptButtonTapSetup() {
        onboardingView.onAcceptButtonTap = {
            self.weatherDataProvider.getUserLocation()
            if userDefaultStorage.isLocationDisabled {
                self.coordinator?.showSettingsAlert()
            }
        }
    }
    
    private func onDeclineButtonTapSetup() {
        if let coordinator = coordinator {
            onboardingView.onDeclineButtonTap = {
                userDefaultStorage.isTrackingBoolKey = false
                if userDefaultStorage.isOnboardingCompleteBoolKey {
                    coordinator.closeOnboardingViewController()
                } else {
                    coordinator.pushSettingsViewController()
                }
            }
        }
    }
    
    @objc func openNextViewController() {
        if userDefaultStorage.isOnboardingCompleteBoolKey {
            Storage.newIndex = 0
            self.coordinator?.closeOnboardingViewController()
        } else {
            self.coordinator?.pushSettingsViewController()
        }
    }
    
    @objc func showAlert() {
        coordinator?.showAlert()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayout() {
        
        view.addSubviews(scrollView)
        scrollView.addSubviews(onboardingView)
        
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            onboardingView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            onboardingView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            onboardingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            onboardingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
