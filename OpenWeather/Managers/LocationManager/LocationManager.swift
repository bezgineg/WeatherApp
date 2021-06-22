
import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: NetworkErrorDelegate?
    
    static let shared = LocationManager()
    let manager = CLLocationManager()
    
    func getCoordinates(city: String, completion: @escaping (Result<CLLocationCoordinate2D, LocationError>) -> Void) {
        CLGeocoder().geocodeAddressString(city.capitalizingFirstLetter()) { (placemark, error) in
            if let _ = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.delegate?.showNetworkAlert()
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
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location,
              let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        getCityName(for: location) { placemark in
            guard let placemark = placemark else { return }
            self.getLocation(coordinates, city: placemark.locality)
        }
    }
    
    private func getLocation(_ coordinate: CLLocationCoordinate2D?, city: String?) {
        guard let coordinates = coordinate else { return }
        let lat = String(coordinates.latitude)
        let long = String(coordinates.longitude)
        print(lat, long)
        NetworkManager.shared.fetchWeather(lat: lat, long: long) { weather in
            let timezone = city ?? separate(weather.timezone)
            let cityWeather = CityWeather(current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)
            RealmDataProvider.shared.addWeather(cityWeather)
            
        }
        
        userDefaultStorage.isCityAdded = true
    }
    
    func getCityName(for location: CLLocation,
                     completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
                
            if let error = error {
                print(error.localizedDescription)
            }
                
            guard let placemark = placemarks?[0] else { return }
            
            completion(placemark)
        }
    }
}
