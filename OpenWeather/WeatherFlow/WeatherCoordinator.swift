
import UIKit

class WeatherCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    let dataProvider = RealmDataProvider()
    
    private var inputTextField: UITextField?
    private let weatherViewController = WeatherViewController()
    
    func start() {
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
    
    func pushOnboardingViewController() {
        let onboardingCoordinater = OnboardingCoordinator()
        onboardingCoordinater.navigationController = navigationController
        childCoordinators.append(onboardingCoordinater)
        onboardingCoordinater.parentCoordinator = self
        onboardingCoordinater.start()
    }
    
    func pushDayViewController(day: CachedDaily, title: String, index: Int) {
        let dayCoordinator = DayCoordinator()
        dayCoordinator.navigationController = navigationController
        childCoordinators.append(dayCoordinator)
        dayCoordinator.parentCoordinator = self
        dayCoordinator.day = day
        dayCoordinator.title = title
        dayCoordinator.index = index
        dayCoordinator.start()
    }
    
    func pushDetailsViewController(title: String) {
        let detailsCoordinator = DetailsCoordinator()
        detailsCoordinator.navigationController = navigationController
        childCoordinators.append(detailsCoordinator)
        detailsCoordinator.parentCoordinator = self
        detailsCoordinator.title = title
        detailsCoordinator.start()
    }
    
    
    func showAlert() {
        let alertController = UIAlertController(title: "Добавление города", message: "Введите название города", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название города"
            self.inputTextField = textField
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            if let cityName = self.inputTextField?.text {
                LocationManager.shared.fetchCoordinates(city: cityName) { (coordinate, error) in
                    
                    if let coordinate = coordinate {
                        let lat = String(coordinate.latitude)
                        let long = String(coordinate.longitude)
                        NetworkManager.fetchWeather(lat: lat, long: long) { weather in
                            let cityWeather = CityWeather(current: weather.current, timezone: weather.timezone, hourly: weather.hourly, daily: weather.daily)
                            let realm = self.dataProvider.getWeather()
                            if realm.isEmpty {
                                self.dataProvider.addWeather(cityWeather)
                            }
                            
                            UserDefaults.standard.setValue(true, forKey: Keys.isCityAdded.rawValue)
                            self.weatherViewController.removePlusView()
                            self.weatherViewController.setupViews()
                        }
                    }
                }
            }
        }
            
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
        }
        
            
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        navigationController?.present(alertController, animated: true, completion: nil)
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


