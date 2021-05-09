
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let mainCoordinator = MainCoordinator()
        mainCoordinator.navigationController = UINavigationController()
        
        NetworkManager.jsonDecodeWeather { weather in
            let weather = WeatherData(current: weather.current, timezone: weather.timezone, daily: weather.daily, hourly: weather.hourly)
            for hour in weather.hourly {
                HourlyWeatherStorage.weather.append(hour)
            }
        }
        

        window.rootViewController = mainCoordinator.navigationController
        mainCoordinator.start()
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

