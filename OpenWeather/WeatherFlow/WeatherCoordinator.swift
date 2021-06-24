
import UIKit

class WeatherCoordinator: Coordinator, WeatherDataProviderDelegate {
    
    weak var parentCoordinator: Coordinator?
    
    let weatherDataProvider: WeatherDataProvider
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    private var inputTextField: UITextField?
    
    init(weatherDataProvider: WeatherDataProvider) {
        self.weatherDataProvider = weatherDataProvider
    }
    
    func start() {
        let pageViewController = PageViewController(weatherDataProvider: weatherDataProvider)
        weatherDataProvider.delegate = self
        weatherDataProvider.updateRealm()
        pageViewController.coordinator = self
        guard let navigator = navigationController else { return }
        navigator.show(pageViewController, sender: self)
    }
    
    func didFinishWeather() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func pushSettingsViewController() {
        let settingsCoordinator = SettingsCoordinator(weatherDataProvider: weatherDataProvider)
        settingsCoordinator.navigationController = navigationController
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.parentCoordinator = self
        settingsCoordinator.start()
    }
    
    func pushOnboardingViewController() {
        let onboardingCoordinater = OnboardingCoordinator(weatherDataProvider: weatherDataProvider)
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
                self.weatherDataProvider.getCoordinates(city: cityName) { result in
                    switch result {
                    case .success(let boolValue):
                        if boolValue {
                            userDefaultStorage.isCityAdded = true
                            NotificationCenter.default.post(name: Notification.Name("updatePageVC"), object: nil)
                        }
                    case .failure(let error):
                        self.showAlert(error: error)
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
    
    func showAlert(error: WeatherError) {
        switch error {
        case .geocodingError:
            let alertController = UIAlertController(title: "Не удалось установить местоположение", message: "Проверьте соединение с интернетом или разрешите приложению отслеживать ваши действия", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            navigationController?.present(alertController, animated: false, completion: nil)
        case .reverseGeocodingError:
            let alertController = UIAlertController(title: "Не удалось найти такой город", message: "Проверьте соединение с интернетом или проверьте название города", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            navigationController?.present(alertController, animated: false, completion: nil)
        case .networkError:
            let alertController = UIAlertController(title: "Проверьте интернет соединение", message: "Соединение с интернетом не установлено. Не удалось загрузить данные о погоде", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            navigationController?.present(alertController, animated: false, completion: nil)
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



