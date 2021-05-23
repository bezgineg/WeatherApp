
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
        weatherCoordinator.parentCoordinator = self
        weatherCoordinator.start()
    }
    
    func closeSettingsViewController() {
        parentCoordinator?.navigationController?.popViewController(animated: true)
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

