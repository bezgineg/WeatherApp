import Foundation

struct Storage {
    static var weatherStorage = [CityWeatherCached?]()
    static var newIndex: Int? = 0
}
