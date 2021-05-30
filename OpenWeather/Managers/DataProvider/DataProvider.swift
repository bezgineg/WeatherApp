protocol DataProviderDelegate: class {
    func weatherDidChange()
}

protocol DataProvider: class {
    var delegate: DataProviderDelegate? { get set }
    func getWeather() -> [CityWeatherCached]
    func addWeather(_ weather: CityWeather)
    func updateWeather(_ weather: CityWeather, index: Int)
}
