
import Foundation

struct HourlyWeatherStorage {
    static var hourlyWeather = [Current]()
    static var dailyWeather = [Daily]()
    static var weather: WeatherData?
}
