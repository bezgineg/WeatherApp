import Foundation

class CityWeather {
    
    let id: String
    let current: Current
    let timezone: String
    let daily: [Daily]
    let hourly: [Current]
    
    init(id: String = UUID().uuidString, current: Current, timezone: String, hourly: [Current], daily:[Daily]) {
        self.id = id
        self.current = current
        self.timezone = timezone
        self.daily = daily
        self.hourly = hourly
    }
}
