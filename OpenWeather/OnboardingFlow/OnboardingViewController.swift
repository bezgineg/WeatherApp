
import UIKit

class OnboardingViewController: UIViewController {
    
    var coordinator: OnboardingCoordinator?
    
    private let onboardingView: OnboardingView = {
        let view = OnboardingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        if let onboardingCoordinator = coordinator {
            onboardingView.onAcceptButtonTap = {
                UserDefaults.standard.setValue(true, forKey: Keys.isTrackingBoolKey.rawValue)
                onboardingCoordinator.pushSettingsViewController()
            }
        }
    }
    
    private func onDeclineButtonTapSetup() {
        if let onboardingCoordinator = coordinator {
            onboardingView.onDeclineButtonTap = {
                UserDefaults.standard.setValue(false, forKey: Keys.isTrackingBoolKey.rawValue)
                onboardingCoordinator.pushSettingsViewController()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(onboardingView)
        
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
