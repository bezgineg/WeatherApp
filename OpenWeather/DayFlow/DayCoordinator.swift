
import UIKit

class DayCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    var day: CachedDaily?
    var title: String?
    var index: Int?
    var weatherStorage: CityWeatherCached?
    
    func start() {
        let dayViewController = DayViewController(weatherStorage: weatherStorage)
        dayViewController.coordinator = self
        dayViewController.detailsDay = day
        dayViewController.city = title
        dayViewController.index = index
        guard let navigator = navigationController else { return }
        navigator.show(dayViewController, sender: self)
    }
    
    func didFinishDay() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func closeDayViewController() {
        parentCoordinator?.navigationController?.popViewController(animated: true)
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
