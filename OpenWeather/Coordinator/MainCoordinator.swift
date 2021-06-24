
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    func start() {
        if userDefaultStorage.isOnboardingCompleteBoolKey {
            let weatherDataProvider = WeatherDataProvider()
            let weatherCoordinator = WeatherCoordinator(weatherDataProvider: weatherDataProvider)
            weatherCoordinator.navigationController = navigationController
            weatherCoordinator.start()
            childCoordinators.append(weatherCoordinator)
            weatherCoordinator.parentCoordinator = self
        } else {
            let weatherDataProvider = WeatherDataProvider()
            let onboardingCoordinator = OnboardingCoordinator(weatherDataProvider: weatherDataProvider)
            onboardingCoordinator.navigationController = navigationController
            onboardingCoordinator.start()
            childCoordinators.append(onboardingCoordinator)
            onboardingCoordinator.parentCoordinator = self
        }
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
