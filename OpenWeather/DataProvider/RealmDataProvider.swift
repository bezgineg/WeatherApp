
import Foundation
import RealmSwift

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
//    let weathers = List<CachedWeatherDetails>()
//
//    convenience init(weathers: [CachedWeatherDetails]) {
//        self.init()
//        self.weathers.append(objectsIn: weathers)
//    }
}

@objcMembers class CachedWeather: Object {
    dynamic var id: String?
    dynamic var current: CachedCurrent? = nil
    dynamic var timezone: String?
    let hourly = List<CachedCurrent>()
//    dynamic var daily: [Daily]?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(hourly: [CachedCurrent]) {
        self.init()
        self.hourly.append(objectsIn: hourly)
    }
}

final class RealmDataProvider: DataProvider {
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather.realm")
        return try? Realm(configuration: config)
    }
    
    private let weathers = [Weather]()
    private let hourlies = [Current]()
    
    func getWeather() -> [CityWeather] {
        return realm?.objects(CachedWeather.self).compactMap {
            guard let id = $0.id, let timezone = $0.timezone, let dt = $0.current?.dt, let humidity = $0.current?.humidity, let sunrise = $0.current?.sunrise, let sunset = $0.current?.sunset, let temp = $0.current?.temp, let feelsLike = $0.current?.feelsLike, let windSpeed = $0.current?.windSpeed, let windDeg = $0.current?.windDeg, let clouds = $0.current?.clouds, let pop = $0.current?.pop, let uvi = $0.current?.uvi else { return nil }
            return CityWeather(id: id, current: Current(dt: dt, humidity: humidity, sunrise: sunrise, sunset: sunset, temp: temp, feelsLike: feelsLike, windSpeed: windSpeed, uvi: uvi, windDeg: windDeg, clouds: clouds, weather: weathers, pop: pop), timezone: timezone, hourly: hourlies)
        } ?? []
    }
    
    func addWeather(_ weather: CityWeather) {
        let cachedWeather = CachedWeather()
        let cachedCurrent = addCurrent(weather)
        let cachedHours = addHourly(weather.hourly)
        
        cachedWeather.id = weather.id
        cachedWeather.current = cachedCurrent
        for cachedHour in cachedHours {
            cachedWeather.hourly.append(cachedHour)
        }
//        cachedWeather.daily = weather.daily
        
        cachedWeather.timezone = weather.timezone
        do {
            try realm?.write {
                realm?.add(cachedWeather)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func updateWeather(_ weather: CityWeather) {
        guard let cachedWeather = realm?.object(ofType: CachedWeather.self, forPrimaryKey: weather.id) else { return }
        
        try? realm?.write {
            cachedWeather.current?.dt = weather.current.dt
            cachedWeather.current?.humidity = weather.current.humidity
            cachedWeather.current?.sunrise = weather.current.sunrise ?? 0
            cachedWeather.current?.sunset = weather.current.sunset ?? 0
            cachedWeather.current?.temp = weather.current.temp
            cachedWeather.current?.feelsLike = weather.current.feelsLike
            cachedWeather.current?.windSpeed = weather.current.windSpeed
            cachedWeather.current?.uvi = weather.current.uvi
            cachedWeather.current?.windDeg = weather.current.windDeg
            cachedWeather.current?.clouds = weather.current.clouds
            cachedWeather.current?.pop = weather.current.pop ?? 0
//            cachedWeather.daily = weather.daily
//            cachedWeather.hourly = weather.hourly
            cachedWeather.timezone = weather.timezone
        }
    }
    
    func deleteWeather(_ weather: CityWeather) {
        guard let cachedWeather = realm?.object(ofType: CachedWeather.self, forPrimaryKey: weather.id) else { return }
        
        try? realm?.write {
            realm?.delete(cachedWeather)
        }
    }
    
    private func addCurrent(_ weather: CityWeather) -> CachedCurrent {
        let cachedCurrent = CachedCurrent()
        cachedCurrent.dt = weather.current.dt
        cachedCurrent.humidity = weather.current.humidity
        cachedCurrent.sunrise = weather.current.sunrise ?? 0
        cachedCurrent.sunset = weather.current.sunset ?? 0
        cachedCurrent.temp = weather.current.temp
        cachedCurrent.feelsLike = weather.current.feelsLike
        cachedCurrent.windSpeed = weather.current.windSpeed
        cachedCurrent.uvi = weather.current.uvi
        cachedCurrent.windDeg = weather.current.windDeg
        cachedCurrent.clouds = weather.current.clouds
        cachedCurrent.pop = weather.current.pop ?? 0
        return cachedCurrent
    }
    
    private func addHourly(_ hours: [Current]) -> [CachedCurrent] {
        var cachedHours = [CachedCurrent]()
        for hour in hours {
            let cachedHour = CachedCurrent()
            cachedHour.dt = hour.dt
            cachedHour.humidity = hour.humidity
            cachedHour.sunrise = hour.sunrise ?? 0
            cachedHour.sunset = hour.sunset ?? 0
            cachedHour.temp = hour.temp
            cachedHour.feelsLike = hour.feelsLike
            cachedHour.windSpeed = hour.windSpeed
            cachedHour.uvi = hour.uvi
            cachedHour.windDeg = hour.windDeg
            cachedHour.clouds = hour.clouds
            cachedHour.pop = hour.pop ?? 0
            cachedHours.append(cachedHour)
        }
        return cachedHours
    }
}
