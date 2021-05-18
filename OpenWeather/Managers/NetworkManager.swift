
import Foundation
import Alamofire

struct NetworkManager {
    
    //static let session = URLSession.shared
    
    static func fetchWeather(completion: @escaping ((WeatherData) -> Void)) {
        let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=55.753215&lon=37.622504&exclude=minutely,alerts&units=metric&lang=ru&appid=\(Constants.apiKey)")
        request.responseDecodable(of: WeatherData.self) { response in
          guard let weather = response.value else {
            debugPrint("Response: \(response)")
            return
          }
            //print(weather)
            completion(weather)
        }
    }
    
//    static func jsonDecodeWeather(completion: @escaping ((WeatherData) -> Void)) {
//        let string = "https://api.openweathermap.org/data/2.5/onecall?lat=55.753215&lon=37.622504&exclude=minutely,alerts&units=metric&lang=ru&appid=\(Constants.apiKey)"
//
//        guard let url = URL(string: string) else { return }
//
//        let jsonDecoder = JSONDecoder()
//
//        NetworkManager.getJson(with: url) { data in
//            if let data = data {
//               do {
//                let weather = try jsonDecoder.decode(WeatherData.self, from: data)
//                completion(weather)
//               } catch let error as NSError {
//                print(error.debugDescription)
//               }
//            }
//        }
//    }
//
//    static func dataTask(with url: URL, completion: @escaping (String?) -> Void) {
//        let task = NetworkManager.session.dataTask(with: url) { data, response, error in
//
//            guard error == nil else {
//                print(error.debugDescription)
//                return
//            }
//
//            if let data = data {
//                completion(String(data: data, encoding: .utf8))
//            }
//        }
//        task.resume()
//    }
//
//    static func getJson(with url: URL, completion: @escaping (Data?) -> Void) {
//        let task = NetworkManager.session.dataTask(with: url) { data, response, error in
//
//            guard error == nil else {
//                print(error.debugDescription)
//                return
//            }
//
//            if let data = data {
//                //print(String(data: data, encoding: .utf8)!)
//                completion(data)
//            }
//
//        }
//        task.resume()
//    }
//
//    static func toObject(json: Data) throws -> Dictionary<String, Any>? {
//        return try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any]
//    }
}

