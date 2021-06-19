
import Foundation

protocol NetworkErrorDelegate: class {
    func showNetworkAlert()
}

enum NetworkError {
    case networkConnectionProblem
}
