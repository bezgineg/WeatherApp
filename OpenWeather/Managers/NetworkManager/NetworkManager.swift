
import Foundation
import Alamofire

class NetworkManager {
    
    
    func fetchWeather(lat: String, long: String, completion: @escaping ((Result<WeatherData, NetworkError>) -> Void)) {
        
        let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts&units=metric&lang=ru&appid=\(Constants.apiKey)")
        request.responseDecodable(of: WeatherData.self) { response in
            guard let weather = response.value else {
                completion(.failure(.networkConnectionProblem))
                print(response.debugDescription)
                return }
            completion(.success(weather))
        }
    }
}

