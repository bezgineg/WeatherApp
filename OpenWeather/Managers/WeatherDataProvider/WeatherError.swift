
import Foundation

enum WeatherError: Error {
    case geocodingError
    case reverseGeocodingError
    case networkError
}
