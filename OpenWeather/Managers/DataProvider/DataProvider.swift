protocol DataProviderDelegate: AnyObject {
    func weatherDidChange()
}

protocol DataProvider: AnyObject {
    var delegate: DataProviderDelegate? { get set }
    func getWeather() -> [CityWeather]
    func addWeather(_ weather: CityWeather)
    func updateWeather(_ weather: CityWeather, id: String)
}
