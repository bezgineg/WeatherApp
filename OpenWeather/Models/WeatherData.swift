
import Foundation

struct WeatherData: Decodable {
    let current: Current
    let timezone: String
    let daily: [Daily]
    let hourly: [Current]
}

struct Current: Decodable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let rain: Rain?
    let windGust, pop: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
        case windGust = "wind_gust"
        case pop
    }
}

struct Weather: Decodable {
    let id: Int
    let main: Main
    let weatherDescription: Description
    //let icon: Icon

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        //case icon
    }
}

struct WeatherElement: Decodable {
    let weatherDescription: Description
    
    enum CodingKeys: String, CodingKey {
            case weatherDescription = "description"
    }
}

struct Rain: Decodable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Daily: Decodable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
}

struct FeelsLike: Decodable {
    let day, night, eve, morn: Double
}

struct Temp: Decodable {
    let day, min, max, night: Double
    let eve, morn: Double
}

enum Description: String, Decodable {
    case дождь = "дождь"
    case небольшаяОблачность = "небольшая облачность"
    case небольшойДождь = "небольшой дождь"
    case облачноСПрояснениями = "облачно с прояснениями"
    case пасмурно = "пасмурно"
    case ясно = "ясно"
    case сильныйДождь = "сильный дождь"
    case переменнаяОблачность = "переменная облачность"
    case проливнойДождь = "проливной дождь"
}

enum Main: String, Decodable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}
