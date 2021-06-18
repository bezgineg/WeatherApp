
import Foundation

struct WeatherData: Decodable {
    let current: Current
    let timezone: String
    let daily: [Daily]
    let hourly: [Current]
}

struct Current: Decodable {
    let dt, humidity: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let windSpeed, uvi: Double
    let windDeg, clouds: Int
    let weather: [Weather]
    let pop: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case humidity, weather
        case uvi, clouds, pop
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
    }
}

struct Weather: Decodable {
    let main: Main
    let weatherDescription: Description

    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
    }
}

struct WeatherElement: Decodable {
    let weatherDescription: Description
    
    enum CodingKeys: String, CodingKey {
            case weatherDescription = "description"
    }
}

struct Daily: Decodable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let humidity: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case humidity
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, pop, uvi
    }
}

struct FeelsLike: Decodable {
    let day, night: Double
}

struct Temp: Decodable {
    let day, min, max, night: Double
}

enum Description: String, Decodable {
    case rain = "дождь"
    case fewClouds = "небольшая облачность"
    case lightRain = "небольшой дождь"
    case scatteredClouds = "облачно с прояснениями"
    case overcastClouds = "пасмурно"
    case clearSky = "ясно"
    case heavyIntensityRain = "сильный дождь"
    case brokenClouds = "переменная облачность"
    case veryHeavyRain = "проливной дождь"
    case moderateRain = "умеренный дождь"
}

enum Main: String, Decodable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}
