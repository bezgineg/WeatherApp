
import Foundation

struct NetworkManager {
//    static let session = URLSession.shared
//
//    static func fetchWeather() {
//        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=55.753215&lon=37.622504&exclude=minutely,alerts&units=metric&lang=ru&appid=\(Constants.apiKey)"
//        guard let url = URL(string: urlString) else { return }
//        NetworkManager.dataTask(with: url) { result in
//            if let result = result {
//                print(result)
//            }
//        }
//    }
//
//    static func dataTask(with url: URL, completion: @escaping (MainInformationWeather?) -> Void) {
//        let task = session.dataTask(with: url) { data, response, error in
//
//            guard error == nil else {
//                print(error.debugDescription)
//                return
//            }
//
//            if let data = data {
//                if let weather = NetworkManager.parseJson(withData: data) {
//                    completion(weather)
//                }
//                //completion(String(data: data, encoding: .utf8))
//            }
//        }
//        task.resume()
//    }
//
//    static func parseJson(withData data: Data) -> MainInformationWeather? {
//        let decoder = JSONDecoder()
//        do {
//            let weatherData = try decoder.decode(WeatherData.self, from: data)
//            guard let weather = MainInformationWeather(weatherData: weatherData) else { return nil }
//            return weather
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
    
    static let session = URLSession.shared
    
    static func jsonDecodeWeather(completion: @escaping ((WeatherData) -> Void)) {
        let string = "https://api.openweathermap.org/data/2.5/onecall?lat=55.753215&lon=37.622504&exclude=minutely,alerts&units=metric&lang=ru&appid=\(Constants.apiKey)"
        
        guard let url = URL(string: string) else { return }
        
        let jsonDecoder = JSONDecoder()
        
        NetworkManager.getJson(with: url) { data in
            if let data = data {
               do {
                let weather = try jsonDecoder.decode(WeatherData.self, from: data)
                completion(weather)
               } catch let error as NSError {
                print(error.debugDescription)
               }
            }
        }
    }
    
    static func dataTask(with url: URL, completion: @escaping (String?) -> Void) {
        let task = NetworkManager.session.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            if let data = data {
                completion(String(data: data, encoding: .utf8))
            }
        }
        task.resume()
    }
    
    static func getJson(with url: URL, completion: @escaping (Data?) -> Void) {
        let task = NetworkManager.session.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                completion(data)
            }
            
        }
        task.resume()
    }
    
    static func toObject(json: Data) throws -> Dictionary<String, Any>? {
        return try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any]
    }
}

