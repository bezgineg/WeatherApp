
import Foundation
import Alamofire

class NetworkManager {
    
    weak var delegate: NetworkErrorDelegate?
    
    static let shared = NetworkManager()
    
    func fetchWeather(lat: String, long: String, completion: @escaping ((WeatherData) -> Void)) {
        
        let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts&units=metric&lang=ru&appid=\(Constants.apiKey)")
        request.responseDecodable(of: WeatherData.self) { response in
          guard let weather = response.value else { return }
            completion(weather)
        }
    }
    
    func updateRealm() {
        guard let cityName = RealmDataProvider.shared.getWeather().first?.timezone else { return }
        LocationManager.shared.getCoordinates(city: cityName) { (coordinate, error) in
            
            if let coordinate = coordinate {
                let lat = String(coordinate.latitude)
                let long = String(coordinate.longitude)
                
                NetworkManager.shared.fetchWeather(lat: lat, long: long) { weather in
                    let timezone = cityName
                    let cityWeather = CityWeather(current: weather.current, timezone: timezone, hourly: weather.hourly, daily: weather.daily)
                    RealmDataProvider.shared.updateWeather(cityWeather)
                }
            }
        }
    }
    
}

