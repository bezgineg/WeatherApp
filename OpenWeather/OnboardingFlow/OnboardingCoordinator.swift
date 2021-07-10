
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
    
    func showAlert() {
        let alertController = UIAlertController(title: "Отслеживание не включено", message: "Чтобы изменить настройки геолокации вам нужно будет перейти в настройки", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            if userDefaultStorage.isOnboardingCompleteBoolKey {
                Storage.newIndex = 0
                self.closeOnboardingViewController()
            } else {
                self.pushSettingsViewController()
            }
        }
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: false, completion: nil)
    }
    
    func showSettingsAlert() {
        let alertController = UIAlertController(title: "Требуется разрешение на местоположение", message: "Пожалуйста, включите разрешения на определение местоположения в настройках.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Настройки", style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}
