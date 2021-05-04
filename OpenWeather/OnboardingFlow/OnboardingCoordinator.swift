
import UIKit

class OnboardingCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    func start() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.coordinator = self
        guard let navigator = navigationController else { return }
        navigator.show(onboardingViewController, sender: self)
    }
    
    func pushSettingsViewController() {
        let settingsCoordinator = SettingsCoordinator()
        settingsCoordinator.navigationController = navigationController
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.parentCoordinator = self
        settingsCoordinator.start()
    }
    
    func didFinishOnboarding() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
