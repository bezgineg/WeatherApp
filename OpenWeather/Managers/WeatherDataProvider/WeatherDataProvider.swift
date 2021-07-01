import UIKit
import CoreLocation

protocol WeatherDataProviderDelegate: class {
    func showAlert(error: WeatherError)
}

protocol ChangeWeatherDelegate: class {
    func weatherDidChange()
}

class WeatherDataProvider: DataProviderDelegate, LocationManagerDelegate {
    
    weak var delegate: WeatherDataProviderDelegate?
    weak var changeWeatherDelegate: ChangeWeatherDelegate?
    
    private let locationManager = LocationManager()
    private let networkManager = NetworkManager()
    private let realm = RealmDataProvider()
    
    init() {
        realm.delegate = self
        locationManager.delegate = self
    }
    
    func weatherDidChange() {
        changeWeatherDelegate?.weatherDidChange()
    }
    
    func getWeather() -> [CityWeatherCached]{
        let storage = realm.getWeather()
        return storage
    }
    
    func getUserLocation() {
        locationManager.getUserLocation()
    }
    
    func getCoordinates(city: String, completion: @escaping (Result<Bool, WeatherError>) -> Void) {
        locationManager.getCoordinates(city: city) { result in
            switch result {
            case .success(let coordinates):
                let lat = String(coordinates.latitude)
                let long = String(coordinates.longitude)
                self.networkManager.fetchWeather(lat: lat, long: long) { networkResult in
                    switch networkResult {
                    case .success(let weather):
                        let timezone = city.capitalizingFirstLetter()
                        let cityWeather = CityWeather(current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)

                        self.realm.addWeather(cityWeather)
                        completion(.success(true))
                    case .failure(_):
                        self.delegate?.showAlert(error: .networkError)
                    }
                }
            case .failure(let error):
                switch error {
                case .cannotFindCoordinates:
                    completion(.failure(.geocodingError))
                case .cannotFindCity:
                    completion(.failure(.reverseGeocodingError))
                }
            }
        }
    }
    
    func updateRealm() {
        let realmStorage = realm.getWeather()
        for (index, city) in realmStorage.enumerated() {
            let cityName = city.timezone
            locationManager.getCoordinates(city: cityName) { result in
                switch result {
                case .success(let coordinates):
                    let lat = String(coordinates.latitude)
                    let long = String(coordinates.longitude)
                    
                    self.networkManager.fetchWeather(lat: lat, long: long) { networkResult in
                        switch networkResult {
                        case .success(let weather):
                            let timezone = cityName
                            let cityWeather = CityWeather(current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)
                            self.realm.updateWeather(cityWeather, index: index)
                        case .failure(_):
                            self.delegate?.showAlert(error: .networkError)
                        }
                    }
                case .failure(let error):
                    switch error {
                    case .cannotFindCoordinates:
                        self.delegate?.showAlert(error: .geocodingError)
                    case .cannotFindCity:
                        self.delegate?.showAlert(error: .reverseGeocodingError)
                    }
                }
            }
        }
    }
    
    func getLocation(_ coordinate: CLLocationCoordinate2D?, city: String?) {
        guard let coordinates = coordinate else { return }
        let lat = String(coordinates.latitude)
        let long = String(coordinates.longitude)
        networkManager.fetchWeather(lat: lat, long: long) { result in
            switch result {
            case .success(let weather):
                let timezone = city ?? separate(weather.timezone)
                let cityWeather = CityWeather(current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)
                self.realm.addWeather(cityWeather)
                userDefaultStorage.isCityAdded = true
                NotificationCenter.default.post(name: Notification.Name("updatePageVC"), object: nil)
            case .failure(_):
                self.delegate?.showAlert(error: .reverseGeocodingError)
            }
        }
    }
}
