
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    func start() {
//        NetworkManager.jsonDecodeWeather { weather in
//            let weather = WeatherData(current: weather.current, timezone: weather.timezone, daily: weather.daily, hourly: weather.hourly)
//            for hour in weather.hourly {
//                HourlyWeatherStorage.weather.append(hour)
//            }
//        }
        if UserDefaults.standard.bool(forKey: Keys.isOnboardingCompleteBoolKey.rawValue) {
            let weatherCoordinator = WeatherCoordinator()
            weatherCoordinator.navigationController = navigationController
            weatherCoordinator.start()
            childCoordinators.append(weatherCoordinator)
            weatherCoordinator.parentCoordinator = self
            UserDefaults.standard.setValue(false, forKey: Keys.isCityAdded.rawValue)
        } else {
            let onboardingCoordinator = OnboardingCoordinator()
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
