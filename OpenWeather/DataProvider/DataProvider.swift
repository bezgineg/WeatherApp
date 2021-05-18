//protocol DataProviderDelegate: class {
//    func weatherDidChange(dataProivider: DataProvider)
//}

protocol DataProvider: class {
    //var delegate: DataProviderDelegate? { get set }
    func getWeather() -> [CityWeather]
    func addWeather(_ weather: CityWeather)
    func updateWeather(_ weather: CityWeather)
}
