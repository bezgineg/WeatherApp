
import UIKit

class SettingsCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    func start() {
        let settingsViewController = SettingsViewController()
        settingsViewController.coordinator = self
        guard let navigator = navigationController else { return }
        navigator.show(settingsViewController, sender: self)
    }
    
    func pushWeatherViewController() {
        let weatherCoordinator = WeatherCoordinator()
        weatherCoordinator.navigationController = navigationController
        childCoordinators.append(weatherCoordinator)
        weatherCoordinator.parentCoordinator = self
        weatherCoordinator.start()
        UserDefaults.standard.setValue(true, forKey: Keys.isSecondLaunchBoolKey.rawValue)
    }
    
    func didFinishSettings() {
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

