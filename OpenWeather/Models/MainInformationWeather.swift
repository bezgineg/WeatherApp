//
//import Foundation
//
//struct MainInformationWeather {
//    var minTemp: Double?
//    var maxTemp: Double?
//    var currentTemp: Double
//    let timezone: String
//    var weatherDescription: String?
//    var clouds: Int
//    var windSpeed: Double
//    var humidity: Int
//    var sunrise: Int?
//    var sunset: Int?
//
//    init?(weatherData: WeatherData) {
//        timezone = weatherData.timezone
//        minTemp = weatherData.daily.first?.temp.min
//        maxTemp = weatherData.daily.first?.temp.max
//        currentTemp = weatherData.current.temp
//        weatherDescription = weatherData.current.weather.first?.weatherDescription.rawValue
//        clouds = weatherData.current.clouds
//        windSpeed = weatherData.current.windSpeed
//        humidity = weatherData.current.humidity
//        sunrise = weatherData.current.sunrise
//        sunset = weatherData.current.sunset
//    }
//}

//enum Description: String, Decodable {
//    case hunderstormWithLightRain = "гроза, небольшой дождь"
//    case thunderstormWithRain = "гроза с дождем"
//    case thunderstormWithHeavyRain = "гроза с сильным дождем"
//    case lightThunderstorm = "легкая гроза"
//    case thunderstorm = "гроза"
//    case heavyThunderstorm = "сильная гроза"
//    case raggedThunderstorm = "рваная гроза"
//    case thunderstormWithLightDrizzle = "гроза с мелким дождиком"
//    case thunderstormWithDrizzle = "гроза с моросью"
//    case thunderstormWithHeavyDrizzle = "гроза с сильным моросящим дождем"
//    case lightIntensityDrizzle = "слабая морось"
//    case drizzle = "морось"
//    case heavyIntensityDrizzle = "сильный дождь"
//    case lightIntensityDrizzleRain = "моросящий дождь слабой интенсивности"
//    case drizzleRain = "моросящий дождь"
//    case heavyIntensityDrizzleRain = "моросящий дождь сильной интенсивности"
//    case showerRainAndDrizzle = "ливень, дождь и изморось"
//    case heavyShowerRainAndDrizzle = "сильный ливень, дождь и изморось"
//    case showerDrizzle = "изморось"
//    case lightRain = "легкий дождь"
//    case moderateRain = "умеренный дождь"
//    case heavyIntensityRain = "asd"
//    case veryHeavyRain = "очень сильный дождь"
//    case extremeRain = "эктремально сильный дождь"
//    case freezingRain = "ледяной дождь"
//    case lightIntensityShowerRain = "ливень слабой интенсивности"
//    case showerRain = "ливень"
//    case heavyIntensityShowerRain = "сильный ливневый дождь"
//    case raggedShowerRain = "рваный ливень"
//    case lightSnow = "легкий снег"
//    case snow = "cнег"
//    case heavySnow = "cнегопад"
//    case sleet = "мокрый снег"
//    case lightShowerSleet = "легкий дождь с мокрым снегом"
//    case showerSleet = "мокрый дождь"
//    case lightRainAndSnow = "небольшой дождь и снег"
//    case rainAndSnow = "дождь и снег"
//    case lightShowerSnow = "легкий снегопад"
//    case showerSnow = "сильный снегопад"
//    case heavyShowerSnow = "очень сильный снегопад"
//    case mist = "туман"
//    case smoke = "дым"
//    case haze = "дымка"
//    case sandDustWhirls = "песчано-пыльные вихри"
//    case fog = "густой туман"
//    case sand = "песчаная погода"
//    case dust = "пыльная погода"
//    case volcanicAsh = "вулканический пепел"
//    case squalls = "шквальный ветер"
//    case tornado = "торнадо"
//    case clearSky = "ясно"
//    case fewClouds = "небольшая облачность"
//    case scatteredСlouds = "рваные тучи"
//    case brokenСlouds = "тучи"
//    case overcastСlouds = "пасмурно"
//}
//
//
