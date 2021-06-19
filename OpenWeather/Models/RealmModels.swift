
import Foundation
import RealmSwift

class CityWeatherCached {
    
    let current: CachedCurrent
    let timezone: String
    let daily: List<CachedDaily>
    let hourly: List<CachedCurrent>
    
    init(current: CachedCurrent, timezone: String, hourly: List<CachedCurrent>, daily: List<CachedDaily>) {
        self.current = current
        self.timezone = timezone
        self.daily = daily
        self.hourly = hourly
    }
}

@objcMembers class CachedWeather: Object {
    dynamic var id: String?
    dynamic var current: CachedCurrent? = nil
    dynamic var timezone: String?
    let hourly = List<CachedCurrent>()
    let daily = List<CachedDaily>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(hourly: [CachedCurrent], daily:[CachedDaily]) {
        self.init()
        self.hourly.append(objectsIn: hourly)
        self.daily.append(objectsIn: daily)
    }
}

@objcMembers class CachedCurrent: Object {
    dynamic var dt = 0
    dynamic var humidity = 0
    dynamic var sunrise = 0
    dynamic var sunset = 0
    dynamic var temp = 0.0
    dynamic var feelsLike = 0.0
    dynamic var windSpeed = 0.0
    dynamic var uvi = 0.0
    dynamic var windDeg = 0
    dynamic var clouds = 0
    dynamic var pop = 0.0
    let weathers = List<CachedWeatherDetails>()

    convenience init(weathers: [CachedWeatherDetails]) {
        self.init()
        self.weathers.append(objectsIn: weathers)
    }
}

@objcMembers class CachedDaily: Object {
    dynamic var dt = 0
    dynamic var sunrise = 0
    dynamic var sunset = 0
    dynamic var moonrise = 0
    dynamic var moonset = 0
    dynamic var moonPhase = 0.0
    dynamic var temp: CachedTemp? = nil
    dynamic var feelsLike: CachedFeelslike? = nil
    dynamic var humidity = 0
    dynamic var windSpeed = 0.0
    dynamic var windDeg = 0
    dynamic var clouds = 0
    dynamic var pop = 0.0
    dynamic var uvi = 0.0

    let weathers = List<CachedWeatherDetails>()

    convenience init(weathers: [CachedWeatherDetails]) {
        self.init()
        self.weathers.append(objectsIn: weathers)
    }
}

@objcMembers class CachedTemp: Object {
    dynamic var day = 0.0
    dynamic var min = 0.0
    dynamic var max = 0.0
    dynamic var night = 0.0
}

@objcMembers class CachedFeelslike: Object {
    dynamic var day = 0.0
    dynamic var night = 0.0
}

class CachedWeatherDetails: Object {
    @objc dynamic var mainRaw = CachedMain.clear.rawValue
    var mainEnum: CachedMain {
        get {
            for mainEnum in CachedMain.allCases where mainRaw == mainEnum.rawValue {
                return mainEnum
            }
            return .clear
        }
        set {
            mainRaw = newValue.rawValue
        }
    }
    
    @objc dynamic var weatherDescriptionRaw = CachedDescription.clearSky.rawValue
    var weatherDescriptionEnum: CachedDescription {
        get {
            for weatherDescriptionEnum in CachedDescription.allCases where weatherDescriptionRaw == weatherDescriptionEnum.rawValue {
                return weatherDescriptionEnum
            }
            return .clearSky
        }
        set {
            weatherDescriptionRaw = newValue.rawValue
        }
    }
}

enum CachedMain: String , CaseIterable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case drizzle = "Drizzle"
}

enum CachedDescription: String, CaseIterable {
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




