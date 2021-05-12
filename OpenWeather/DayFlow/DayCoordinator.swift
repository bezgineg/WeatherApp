
import UIKit

class DayCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    var day: Daily?
    var title: String?
    
    func start() {
        let dayViewController = DayViewController()
        dayViewController.coordinator = self
        dayViewController.detailsDay = day
        dayViewController.city = title
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
