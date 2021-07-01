
import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func getLocation(_ coordinate: CLLocationCoordinate2D?, city: String?)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: LocationManagerDelegate?
    
    let manager = CLLocationManager()
    
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
        } else {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        loadWeather()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted:
            userDefaultStorage.isTrackingBoolKey = false
        case .denied:
            pushNotification()
            userDefaultStorage.isTrackingBoolKey = false
        case .authorizedAlways, .authorizedWhenInUse:
            pushNotification()
            userDefaultStorage.isTrackingBoolKey = true
        @unknown default:
            userDefaultStorage.isTrackingBoolKey = false
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
    
    private func pushNotification() {
        NotificationCenter.default.post(name: Notification.Name("onboardingNavigation"), object: nil)
    }
    
    private func loadWeather() {
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
}
