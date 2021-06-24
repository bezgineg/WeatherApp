
import UIKit

class OnboardingCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    let weatherDataProvider: WeatherDataProvider
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    init(weatherDataProvider: WeatherDataProvider) {
        self.weatherDataProvider = weatherDataProvider
    }
    
    func start() {
        let onboardingViewController = OnboardingViewController(weatherDataProvider: weatherDataProvider)
        onboardingViewController.coordinator = self
        guard let navigator = navigationController else { return }
        navigator.show(onboardingViewController, sender: self)
    }
    
    func pushSettingsViewController() {
        let settingsCoordinator = SettingsCoordinator(weatherDataProvider: weatherDataProvider)
        settingsCoordinator.navigationController = navigationController
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.parentCoordinator = self
        settingsCoordinator.start()
    }
    
    func closeOnboardingViewController() {
        parentCoordinator?.navigationController?.popViewController(animated: true)
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
