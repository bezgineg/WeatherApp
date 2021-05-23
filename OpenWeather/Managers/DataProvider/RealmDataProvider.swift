
import Foundation
import RealmSwift

final class RealmDataProvider: DataProvider {
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather.realm")
        return try? Realm(configuration: config)
    }
    
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
    
    func getNewWeather(_ weather: CityWeather) -> CachedWeather {
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
        
        return cachedWeather
    }
    
    func updateWeather(_ weather: CityWeather) {
        guard let cachedWeather = realm?.objects(CachedWeather.self).first else { return }
        
        let newWeather = getNewWeather(weather)
        
        try? realm?.write {
            cachedWeather.current = newWeather.current
            cachedWeather.daily.removeAll()
            cachedWeather.daily.append(objectsIn: newWeather.daily)
            cachedWeather.hourly.removeAll()
            cachedWeather.hourly.append(objectsIn: newWeather.hourly)
            cachedWeather.timezone = newWeather.timezone
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
