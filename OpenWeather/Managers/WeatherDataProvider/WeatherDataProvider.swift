import UIKit
import CoreLocation

protocol WeatherDataProviderDelegate: AnyObject {
    func showAlert(error: WeatherError)
}

protocol ChangeWeatherDelegate: AnyObject {
    func weatherDidChange()
}

class WeatherDataProvider: DataProviderDelegate, LocationManagerDelegate {
    
    weak var delegate: WeatherDataProviderDelegate?
    weak var changeWeatherDelegate: ChangeWeatherDelegate?
    
    private let locationManager = LocationManager()
    private let networkManager = NetworkManager()
    private let realm = RealmDataProvider()
    
    private var storage: StorageService
    
    init(storage: StorageService = UserDefaultStorage.shared) {
        self.storage = storage
        realm.delegate = self
        locationManager.delegate = self
    }
    
    func weatherDidChange() {
        changeWeatherDelegate?.weatherDidChange()
    }
    
    func getWeather() -> [CityWeather]{
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
        for city in realmStorage {
            let cityName = city.timezone
            let cityId = city.id
            print(cityId)
            locationManager.getCoordinates(city: cityName) { result in
                switch result {
                case .success(let coordinates):
                    let lat = String(coordinates.latitude)
                    let long = String(coordinates.longitude)
                    self.networkManager.fetchWeather(lat: lat, long: long) { networkResult in
                        switch networkResult {
                        case .success(let weather):
                            let timezone = cityName
                            let cityWeather = CityWeather(id: cityId, current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)
                            self.realm.updateWeather(cityWeather, id: cityId)
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
                self.storage.isCityAdded = true
                NotificationCenter.default.post(name: .updatePageVC, object: nil)
            case .failure(_):
                self.delegate?.showAlert(error: .reverseGeocodingError)
            }
        }
    }
}
