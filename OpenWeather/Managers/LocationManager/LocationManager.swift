
import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func getLocation(_ coordinate: CLLocationCoordinate2D?, city: String?)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: LocationManagerDelegate?
    
    let manager = CLLocationManager()
    
    private var storage: StorageService
    
    init(storage: StorageService = UserDefaultStorage.shared) {
        self.storage = storage
    }
    
    func getCoordinates(city: String, completion: @escaping (Result<CLLocationCoordinate2D, LocationError>) -> Void) {
        CLGeocoder().geocodeAddressString(city.capitalizingFirstLetter()) { (placemark, error) in
            if let _ = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    completion(.failure(.cannotFindCoordinates))
                }
            }
            
            if let location = placemark?.first?.location {
                completion(.success(location.coordinate))
            } else {
                completion(.failure(.cannotFindCoordinates))
            }
        }
    }
    
    func getUserLocation() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location,
              let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        getCityName(for: location) { result in
            switch result {
            case.success(let placemark):
                self.delegate?.getLocation(coordinates, city: placemark.locality)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted:
            storage.isTrackingBoolKey = false
            storage.isLocationDisabled = true
        case .notDetermined:
            storage.isTrackingBoolKey = false
            storage.isLocationDisabled = false
        case .denied:
            showAlert()
            storage.isTrackingBoolKey = false
            storage.isLocationDisabled = true
        case .authorizedAlways, .authorizedWhenInUse:
            openNextViewController()
            storage.isTrackingBoolKey = true
            storage.isLocationDisabled = false
        @unknown default:
            break
        }
    }
    
    func getCityName(for location: CLLocation,
                     completion: @escaping (Result<CLPlacemark, LocationError>) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
                
            if let error = error {
                print(error.localizedDescription)
            }
                
            guard let placemark = placemarks?[0] else {
                completion(.failure(.cannotFindCity))
                return
            }
            
            completion(.success(placemark))
        }
    }
    
    private func openNextViewController() {
        NotificationCenter.default.post(name: .openNextViewController, object: nil)
    }
    
    private func showAlert() {
        NotificationCenter.default.post(name: .showAlert, object: nil)
    }
}
