
import UIKit

class WeatherCoordinator: Coordinator, NetworkErrorDelegate {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    private var inputTextField: UITextField?
    private let pageViewController = PageViewController()
    
    func start() {
        NetworkManager.shared.delegate = self
        LocationManager.shared.delegate = self
        NetworkManager.shared.updateRealm()
        pageViewController.coordinator = self
        guard let navigator = navigationController else { return }
        navigator.show(pageViewController, sender: self)
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
    
    func pushDayViewController(day: CachedDaily, title: String, index: Int, weatherStorage: CityWeatherCached?) {
        let dayCoordinator = DayCoordinator()
        dayCoordinator.navigationController = navigationController
        childCoordinators.append(dayCoordinator)
        dayCoordinator.parentCoordinator = self
        dayCoordinator.weatherStorage = weatherStorage
        dayCoordinator.day = day
        dayCoordinator.title = title
        dayCoordinator.index = index
        dayCoordinator.start()
    }
    
    func pushDetailsViewController(title: String, weatherStorage: CityWeatherCached?) {
        let detailsCoordinator = DetailsCoordinator()
        detailsCoordinator.navigationController = navigationController
        childCoordinators.append(detailsCoordinator)
        detailsCoordinator.parentCoordinator = self
        detailsCoordinator.title = title
        detailsCoordinator.weatherStorage = weatherStorage
        detailsCoordinator.start()
    }
    
    
    func showAddCityAlert() {
        let alertController = UIAlertController(title: "Добавление города", message: "Введите название города", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название города"
            self.inputTextField = textField
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            if let cityName = self.inputTextField?.text {
                LocationManager.shared.getCoordinates(city: cityName) { (coordinate, error) in
                    
                    if let _ = error {
                        self.showNetworkAlert()
                    }
                    
                    if let coordinate = coordinate {
                        let lat = String(coordinate.latitude)
                        let long = String(coordinate.longitude)
                        print(lat, long)
                        NetworkManager.shared.fetchWeather(lat: lat, long: long) { weather in
                            let timezone = cityName
                            let cityWeather = CityWeather(current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)
                            //let realm = RealmDataProvider.shared.getWeather()

                            RealmDataProvider.shared.addWeather(cityWeather)
                            
            
                            UserDefaults.standard.setValue(true, forKey: Keys.isCityAdded.rawValue)
                            self.pageViewController.update()
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
    
    func showNetworkAlert() {
        let alertController = UIAlertController(title: "Проверьте интернет соединение", message: "Соединение с интернетом не установлено. Не удалось загрузить данные о погоде", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: false, completion: nil)
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



