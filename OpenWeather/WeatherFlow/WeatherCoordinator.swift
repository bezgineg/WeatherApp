
import UIKit

class WeatherCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    func start() {
        let weatherViewController = WeatherViewController()
        weatherViewController.coordinator = self
        guard let navigator = navigationController else { return }
        navigator.show(weatherViewController, sender: self)
    }
    
    func didFinishWeather() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func pushSettingsViewController() {
        let settingsCoordinator = SettingsCoordinator()
        settingsCoordinator.navigationController = navigationController
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.parentCoordinator = self
        settingsCoordinator.start()
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


