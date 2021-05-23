
import UIKit

class OnboardingViewController: UIViewController {
    
    var coordinator: OnboardingCoordinator?
    
    private let onboardingView: OnboardingView = {
        let view = OnboardingView()
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.mainColor

        setupNavigationBar()
        setupLayout()
        onAcceptButtonTapSetup()
        onDeclineButtonTapSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.didFinishOnboarding()
    }
    
    private func onAcceptButtonTapSetup() {
        if let coordinator = coordinator {
            onboardingView.onAcceptButtonTap = {
                LocationManager.shared.getUserLocation()
                UserDefaults.standard.setValue(true, forKey: Keys.isTrackingBoolKey.rawValue)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if UserDefaults.standard.bool(forKey: Keys.isOnboardingCompleteBoolKey.rawValue) {
                        coordinator.closeOnboardingViewController()
                    } else {
                        coordinator.pushSettingsViewController()
                    }
                }
            }
        }
    }
    
    private func onDeclineButtonTapSetup() {
        if let coordinator = coordinator {
            onboardingView.onDeclineButtonTap = {
                UserDefaults.standard.setValue(false, forKey: Keys.isTrackingBoolKey.rawValue)
                if UserDefaults.standard.bool(forKey: Keys.isOnboardingCompleteBoolKey.rawValue) {
                    coordinator.closeOnboardingViewController()
                } else {
                    coordinator.pushSettingsViewController()
                }
            }
        }
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
