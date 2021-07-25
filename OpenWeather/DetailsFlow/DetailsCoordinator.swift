import UIKit

class DetailsCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    var title: String?
    var weatherStorage: CityWeather?
    
    func start() {
        let detailsViewController = DetailsViewController(weatherStorage: weatherStorage)
        Storage.weatherStorage.removeAll()
        Storage.weatherStorage.append(weatherStorage)
        detailsViewController.coordinator = self
        detailsViewController.city = title
        guard let navigator = navigationController else { return }
        navigator.show(detailsViewController, sender: self)
    }
    
    func didFinishDetails() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func closeDetailsViewController() {
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
