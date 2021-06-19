
import Foundation

protocol LocationErrorDelegate: class {
    func showLocationAlert(error: LocationError)
}

enum LocationError: Error {
    case cannotFindCoordinates
}
