
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    private let dataProvider = RealmDataProvider()
    
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
            NetworkManager.fetchWeather(lat: "55.753215", long: "37.622504") { weather in
                let realm = self.dataProvider.getWeather()
                if realm.isEmpty {
                    let cityWeather = CityWeather(current: weather.current, timezone: weather.timezone, hourly: weather.hourly, daily: weather.daily)
                    self.dataProvider.addWeather(cityWeather)
                }
            }
            UserDefaults.standard.setValue(true, forKey: Keys.isCityAdded.rawValue)
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
