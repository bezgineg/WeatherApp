
import Foundation

struct MainInformationWeather {
    var minTemp: Double?
    var maxTemp: Double?
    var currentTemp: Double
    let timezone: String
    var weatherDescription: String?
    var clouds: Int
    var windSpeed: Double
    var humidity: Int
    var sunrise: Int?
    var sunset: Int?
    
    init?(weatherData: WeatherData) {
        timezone = weatherData.timezone
        minTemp = weatherData.daily.first?.temp.min
        maxTemp = weatherData.daily.first?.temp.max
        currentTemp = weatherData.current.temp
        weatherDescription = weatherData.current.weather.first?.weatherDescription.rawValue
        clouds = weatherData.current.clouds
        windSpeed = weatherData.current.windSpeed
        humidity = weatherData.current.humidity
        sunrise = weatherData.current.sunrise
        sunset = weatherData.current.sunset
    }
}


