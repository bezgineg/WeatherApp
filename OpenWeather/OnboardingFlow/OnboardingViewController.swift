
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
                userDefaultStorage.isTrackingBoolKey = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if userDefaultStorage.isOnboardingCompleteBoolKey {
                        Storage.newIndex = 0
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
                userDefaultStorage.isTrackingBoolKey = false
                if userDefaultStorage.isOnboardingCompleteBoolKey {
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
