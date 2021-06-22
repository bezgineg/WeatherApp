
import Foundation

func fahrenheitConversion(_ value: Double) -> Int {
    return Int(value/9*5+32)
}

func separate(_ cityName: String) -> String {
    let cityNameArray = cityName.split(separator: "/")
    guard let city = cityNameArray.last else { return cityName }
    return String(city)
}

