
import Foundation
import RealmSwift

@objcMembers class CachedWeather: Object {
    dynamic var id: String?
    dynamic var current: Current?
    dynamic var timezone: String?
    dynamic var daily: [Daily]?
    dynamic var hourly: [Current]?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class RealmDataProvider: DataProvider {
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("weather.realm")
        return try? Realm(configuration: config)
    }
    
    func getWeather() -> [CityWeather] {
        return realm?.objects(CachedWeather.self).compactMap {
            guard let id = $0.id, let current = $0.current, let timezone = $0.timezone, let daily = $0.daily, let hourly = $0.hourly else { return nil }
            return CityWeather(id: id, current: current, timezone: timezone, daily: daily, hourly: hourly)
        } ?? []
    }
    
    func addWeather(_ weather: CityWeather) {
        let cachedWeather = CachedWeather()
        cachedWeather.id = weather.id
        cachedWeather.current = weather.current
        cachedWeather.daily = weather.daily
        cachedWeather.hourly = weather.hourly
        cachedWeather.timezone = weather.timezone
        do {
            try realm?.write {
                realm?.add(cachedWeather)
                print(cachedWeather)
                let w = getWeather()
                print(w.count)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
//        try? realm?.write {
//            realm?.add(cachedWeather)
//        }
    }
    
    func updateWeather(_ weather: CityWeather) {
        guard let cachedWeather = realm?.object(ofType: CachedWeather.self, forPrimaryKey: weather.id) else { return }
        
        try? realm?.write {
            cachedWeather.current = weather.current
            cachedWeather.daily = weather.daily
            cachedWeather.hourly = weather.hourly
            cachedWeather.timezone = weather.timezone
        }
    }
    
    func deleteWeather(_ weather: CityWeather) {
        guard let cachedWeather = realm?.object(ofType: CachedWeather.self, forPrimaryKey: weather.id) else { return }
        
        try? realm?.write {
            realm?.delete(cachedWeather)
        }
    }
}
