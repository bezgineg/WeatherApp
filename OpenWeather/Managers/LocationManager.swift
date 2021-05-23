
import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    let dataProvider = RealmDataProvider()
    
    func fetchCoordinates(city: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(city) { (placemark, error) in
            completion(placemark?.first?.location?.coordinate, error)
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
        guard let coordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        getLocation(coordinates)
        
    }
    
    private func getLocation(_ coordinate: CLLocationCoordinate2D?) {
        guard let coordinates = coordinate else { return }
        print(coordinates.latitude, coordinates.longitude)
        let lat = String(coordinates.latitude)
        let long = String(coordinates.longitude)
        NetworkManager.fetchWeather(lat: lat, long: long) { weather in
            let cityWeather = CityWeather(current: weather.current, timezone: weather.timezone, hourly: weather.hourly, daily: weather.daily)
            let realm = self.dataProvider.getWeather()
            if realm.isEmpty {
                self.dataProvider.addWeather(cityWeather)
            }
        }

        UserDefaults.standard.setValue(true, forKey: Keys.isCityAdded.rawValue)
    }
}
