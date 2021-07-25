import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController : UINavigationController? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator?)
}
