
import Foundation
import RealmSwift

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
    
    var parentCachedWeather = LinkingObjects(fromType: CachedWeather.self, property: "hourly")

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
    
    var parentCachedWeather = LinkingObjects(fromType: CachedWeather.self, property: "daily")
    
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
            for main in CachedMain.allCases where mainRaw == main.rawValue {
                return main
            }
            return .clear
        }
        set {
            mainRaw = newValue.rawValue
        }
    }
    
    @objc dynamic var weatherDescriptionRaw = CachedDescription.ясно.rawValue
    var weatherDescriptionEnum: CachedDescription {
        get {
            for weatherDescription in CachedDescription.allCases where weatherDescriptionRaw == weatherDescription.rawValue {
                return weatherDescription
            }
            return .ясно
        }
        set {
            weatherDescriptionRaw = newValue.rawValue
        }
    }

    var parentCachedCurrent = LinkingObjects(fromType: CachedCurrent.self, property: "weathers")
    var parentCachedDaily = LinkingObjects(fromType: CachedDaily.self, property: "weathers")
}

enum CachedMain: String , CaseIterable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum CachedDescription: String, CaseIterable {
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



