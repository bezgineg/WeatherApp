
import Foundation

struct WeatherData: Decodable {
    let current: Current
    let timezone: String
    let daily: [Daily]
}

struct Current: Decodable {
    let temp: Double
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let windSpeed: Double
    let clouds: Int
    let weather: [WeatherElement]
    
    enum CodingKeys: String, CodingKey {
            case sunrise, sunset, temp, humidity, clouds, weather
            case windSpeed = "wind_speed"
    }
    
}

struct WeatherElement: Decodable {
    let weatherDescription: Description
    
    enum CodingKeys: String, CodingKey {
            case weatherDescription = "description"
    }
}

struct Daily: Decodable {
    let temp: Temp
}

struct Temp: Decodable {
    let min: Double
    let max: Double
}

enum Description: String, Decodable {
    case дождь = "дождь"
    case небольшаяОблачность = "небольшая облачность"
    case небольшойДождь = "небольшой дождь"
    case облачноСПрояснениями = "облачно с прояснениями"
    case пасмурно = "пасмурно"
    case ясно = "ясно"
}
