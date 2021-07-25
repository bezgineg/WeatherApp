
import Foundation
import RealmSwift

class RealmDataProvider: DataProvider {
    
    weak var delegate: DataProviderDelegate?
    
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather.realm")
        return try? Realm(configuration: config)
    }
    
    func getWeather() -> [CityWeather] {
        var storage = [CityWeather]()
        guard let weatherStorage = realm?.objects(CachedWeather.self) else { return [] }
        for weather in weatherStorage {
            guard let timezone = weather.timezone,
                  let cachedCurrent = weather.current,
                  let id = weather.id else { return [] }
            let current = getCurrent(cachedCurrent)
            let daily = getDaily(weather.daily)
            let hourly = getHourly(weather.hourly)
            storage.append(CityWeather(id: id, current: current, timezone: timezone, hourly: hourly, daily: daily))
        }
        return storage
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
    
    func updateWeather(_ weather: CityWeather, id: String) {

        guard let cachedWeather = realm?.objects(CachedWeather.self).filter("id = %@", id) else {
            return }
        let newWeather = getNewWeather(weather)
        if let weather = cachedWeather.first {
            try? realm?.write {
                weather.current = newWeather.current
                weather.daily.removeAll()
                weather.daily.append(objectsIn: newWeather.daily)
                weather.hourly.removeAll()
                weather.hourly.append(objectsIn: newWeather.hourly)
                weather.timezone = newWeather.timezone
            }
        }
        
        delegate?.weatherDidChange()
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
        cachedWeather.current = cachedCurrent
        cachedWeather.timezone = weather.timezone
        
        return cachedWeather
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
    
    private func getCurrent(_ cachedCurrent: CachedCurrent) -> Current {
        var currentWeather = [Weather]()
        for el in cachedCurrent.weathers {
            guard let main = Main(rawValue: el.mainRaw),
                  let descr = Description(rawValue: el.weatherDescriptionRaw) else {
                return Current(dt: 0, humidity: 0, sunrise: 0, sunset: 0, temp: 0, feelsLike: 0, windSpeed: 0, uvi: 0, windDeg: 0, clouds: 0, weather: [], pop: 0)
            }
            let newEl = Weather(main: main, weatherDescription: descr)
            currentWeather.append(newEl)
        }
        let current = Current(dt: cachedCurrent.dt, humidity: cachedCurrent.humidity, sunrise: cachedCurrent.sunrise, sunset: cachedCurrent.sunrise, temp: cachedCurrent.temp, feelsLike: cachedCurrent.feelsLike, windSpeed: cachedCurrent.windSpeed, uvi: cachedCurrent.uvi, windDeg: cachedCurrent.windDeg, clouds: cachedCurrent.clouds, weather: currentWeather, pop: cachedCurrent.pop)
        return current
    }
    
    private func getDaily(_ daily: List<CachedDaily>) -> [Daily] {
        var dailyWeather = [Daily]()
        for el in daily {
            guard let temp = el.temp,
                  let feelsLike = el.feelsLike else { return [Daily(dt: 0, sunrise: 0, sunset: 0, moonrise: 0, moonset: 0, moonPhase: 0, temp: Temp(day: 0, min: 0, max: 0, night: 0), feelsLike: FeelsLike(day: 0, night: 0), humidity: 0, windSpeed: 0, windDeg: 0, weather: [Weather](), clouds: 0, pop: 0, uvi: 0)]
                
            }
            let newTemp = Temp(day: temp.day, min: temp.min, max: temp.max, night: temp.night)
            let newFeelsLike = FeelsLike(day: feelsLike.day, night: feelsLike.night)
            var newWeather = [Weather]()
            for el in el.weathers {
                guard let main = Main(rawValue: el.mainRaw),
                      let descr = Description(rawValue: el.weatherDescriptionRaw) else {
                    return [Daily(dt: 0, sunrise: 0, sunset: 0, moonrise: 0, moonset: 0, moonPhase: 0, temp: Temp(day: 0, min: 0, max: 0, night: 0), feelsLike: FeelsLike(day: 0, night: 0), humidity: 0, windSpeed: 0, windDeg: 0, weather: [Weather](), clouds: 0, pop: 0, uvi: 0)]
                }
                let newEl = Weather(main: main, weatherDescription: descr)
                newWeather.append(newEl)
            }
            let newEl = Daily(dt: el.dt, sunrise: el.sunrise, sunset: el.sunset, moonrise: el.moonrise, moonset: el.moonset, moonPhase: el.moonPhase, temp: newTemp, feelsLike: newFeelsLike, humidity: 0, windSpeed: 0, windDeg: 0, weather: newWeather, clouds: 0, pop: 0, uvi: 0)
            dailyWeather.append(newEl)
        }
        return dailyWeather
    }
    
    private func getHourly(_ hourly: List<CachedCurrent>) -> [Current] {
        var currentArr = [Current]()
        for el in hourly {
            var currentWeather = [Weather]()
            for el in el.weathers {
                guard let main = Main(rawValue: el.mainRaw),
                      let descr = Description(rawValue: el.weatherDescriptionRaw) else {
                    return [Current(dt: 0, humidity: 0, sunrise: 0, sunset: 0, temp: 0, feelsLike: 0, windSpeed: 0, uvi: 0, windDeg: 0, clouds: 0, weather: [], pop: 0)]
                }
                let newEl = Weather(main: main, weatherDescription: descr)
                currentWeather.append(newEl)
            }
            let current = Current(dt: el.dt, humidity: el.humidity, sunrise: el.sunrise, sunset: el.sunrise, temp: el.temp, feelsLike: el.feelsLike, windSpeed: el.windSpeed, uvi: el.uvi, windDeg: el.windDeg, clouds: el.clouds, weather: currentWeather, pop: el.pop)
            currentArr.append(current)
        }
        return currentArr
    }
}
