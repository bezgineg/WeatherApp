
import Foundation
import Alamofire

class NetworkManager {
    
    weak var networkDelegate: NetworkErrorDelegate?
    weak var locationDelegate: LocationErrorDelegate?
    
    static let shared = NetworkManager()
    
    func fetchWeather(lat: String, long: String, completion: @escaping ((WeatherData) -> Void)) {
        
        let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts&units=metric&lang=ru&appid=\(Constants.apiKey)")
        request.responseDecodable(of: WeatherData.self) { response in
            guard let weather = response.value else { return }
            completion(weather)
        }
    }
    
    func updateRealm() {
        let realm = RealmDataProvider.shared.getWeather()
        for (index, city) in realm.enumerated() {
            let cityName = city.timezone
            LocationManager.shared.getCoordinates(city: cityName) { result in
                switch result {
                case .success(let coordinates):
                    let lat = String(coordinates.latitude)
                    let long = String(coordinates.longitude)
                    
                    NetworkManager.shared.fetchWeather(lat: lat, long: long) { weather in
                        let timezone = cityName
                        let cityWeather = CityWeather(current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)
                        RealmDataProvider.shared.updateWeather(cityWeather, index: index)
                    }
                case .failure(let error):
                    self.locationDelegate?.showLocationAlert(error: error)
                }
            }
        }
    }
}

