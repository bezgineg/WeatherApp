
import Foundation
import RealmSwift

extension RealmCollection
{
  func toArray<T>() ->[T]
  {
    return self.compactMap{$0 as? T}
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
    private let daylies = [Daily]()
    
//    private func getCurrent() -> Current {
//        dynamic var dt = 0
//        dynamic var humidity = 0
//        dynamic var sunrise = 0
//        dynamic var sunset = 0
//        dynamic var temp = 0.0
//        dynamic var feelsLike = 0.0
//        dynamic var windSpeed = 0.0
//        dynamic var uvi = 0.0
//        dynamic var windDeg = 0
//        dynamic var clouds = 0
//        dynamic var pop = 0.0
//        //let weathers = List<CachedWeatherDetails>()
//        return realm?.object(CachedCurrent.self).compactMap {
//            guard let dt = $0.current?.dt, let humidity = $0.current?.humidity, let sunrise = $0.current?.sunrise, let sunset = $0.current?.sunset, let temp = $0.current?.temp, let feelsLike = $0.current?.feelsLike, let windSpeed = $0.current?.windSpeed, let windDeg = $0.current?.windDeg, let clouds = $0.current?.clouds, let pop = $0.current?.pop, let uvi = $0.current?.uvi else { return nil}
//            return Current
//        }
//    }
    
    func getWeather() -> [CityWeatherCached] {
        guard let weather = realm?.objects(CachedWeather.self) else { return [] }
        guard let timezone = weather.first?.timezone, let current = weather.first?.current, let daily = weather.first?.daily,
              let hourly = weather.first?.hourly else { return [] }
        return [CityWeatherCached(current: current, timezone: timezone, hourly: hourly, daily: daily)]
        
    }
    
    func addWeather(_ weather: CityWeather) {
        let cachedWeather = CachedWeather()
        let cachedCurrent = addCurrent(weather)
        let cachedHours = addHourly(weather.hourly)
        let cachedDays = addDaily(weather.daily)
        
        for cachedHour in cachedHours {
            cachedWeather.hourly.append(cachedHour)
        }
        for cachedDay in cachedDays {
            cachedWeather.daily.append(cachedDay)
        }
        cachedWeather.id = weather.id
        cachedWeather.current = cachedCurrent
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
    
    private func addWeatherDetails(_ weathers: [Weather]) -> [CachedWeatherDetails] {
        var cachedWeatherDetail = [CachedWeatherDetails]()
        for weather in weathers {
            let cachedWeather = CachedWeatherDetails()
            cachedWeather.mainRaw = weather.main.rawValue
            cachedWeather.weatherDescriptionRaw = weather.weatherDescription.rawValue
            cachedWeatherDetail.append(cachedWeather)
        }
//        for weather in weathers {
//            let cachedWeather = CachedWeatherDetails()
//            let cachedMain = CachedMain(rawValue: weather.main.rawValue)
//            cachedWeather.mainEnum = cachedMain.
//        }
        return cachedWeatherDetail
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
        
        let cachedWeatherDetails = addWeatherDetails(weather.current.weather)
        for cachedWeather in cachedWeatherDetails {
            cachedCurrent.weathers.append(cachedWeather)
        }
        
        return cachedCurrent
    }
    
    private func addHourly(_ hours: [Current]) -> [CachedCurrent] {
        var cachedHours = [CachedCurrent]()
        for hour in hours {
            let cachedHour = CachedCurrent()
            let cachedWeatherDetails = addWeatherDetails(hour.weather)
            
            for cachedWeather in cachedWeatherDetails {
                cachedHour.weathers.append(cachedWeather)
            }
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
    
    private func addDaily(_ days: [Daily]) -> [CachedDaily] {
        var cachedDays = [CachedDaily]()
        for day in days {
            let cachedDay = CachedDaily()
            
            let cachedWeatherDetails = addWeatherDetails(day.weather)
            
            for cachedWeather in cachedWeatherDetails {
                cachedDay.weathers.append(cachedWeather)
            }
            cachedDay.dt =  day.dt
            cachedDay.humidity = day.humidity
            cachedDay.sunrise = day.sunrise
            cachedDay.sunset = day.sunset
            cachedDay.moonrise = day.moonrise
            cachedDay.moonset = day.moonset
            cachedDay.moonPhase = day.moonPhase
            cachedDay.windSpeed = day.windSpeed
            cachedDay.uvi = day.uvi
            cachedDay.windDeg = day.windDeg
            cachedDay.clouds = day.clouds
            cachedDay.pop = day.pop
            
            let cachedFeelsLike = CachedFeelslike()
            cachedFeelsLike.day = day.feelsLike.day
            cachedFeelsLike.night = day.feelsLike.night
            cachedDay.feelsLike = cachedFeelsLike
            
            let cachedTemp = CachedTemp()
            cachedTemp.day = day.temp.day
            cachedTemp.max = day.temp.max
            cachedTemp.min = day.temp.min
            cachedTemp.night = day.temp.night
            cachedDay.temp = cachedTemp
            
            cachedDays.append(cachedDay)
        }
        return cachedDays
    }
}
