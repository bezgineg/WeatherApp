
import UIKit
import CoreLocation
import RealmSwift

class WeatherViewController: UIViewController {

    var coordinator: WeatherCoordinator?
    
    let dataProvider: DataProvider = RealmDataProvider()
    private let everyDayTableView = UITableView(frame: .zero, style: .plain)
    
    private let mainInformationView: MainInformationView = {
        let view = MainInformationView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let plusView: PlusView = {
        let view = PlusView()
        return view
    }()
    
    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Подробнее на 24 часа", for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 0.0)
        button.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
        button.underline()
        return button
    }()
    
    private lazy var hourlyCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HourlyCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let everyDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Ежедневный прогноз"
        return label
    }()
    
    private var everyDayReuseID: String {
        return String(describing: EveryDayTableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        if UserDefaults.standard.bool(forKey: Keys.isTrackingBoolKey.rawValue) {
            //getLocation()
        }
        
        if UserDefaults.standard.bool(forKey: Keys.isOnboardingCompleteBoolKey.rawValue) {
            guard let weather = dataProvider.getWeather().first else { return }
            mainInformationView.setupDate()
            mainInformationView.setupSunriseAndSunsetDate(sunrise: weather.current.sunrise , sunset: weather.current.sunset )
            mainInformationView.setupWindSpeed(with: weather)
            mainInformationView.setupTemperature(with: weather)
            hourlyCollectionView.reloadData()
            everyDayTableView.reloadData()
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        coordinator?.didFinishWeather()
//    }
    
    func removePlusView() {
        plusView.removeFromSuperview()
    }
    
    private func getLocation() {
      let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestLocation()
    }
    
    private func createTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc private func updateData() {
        configureMainInformationView()
        guard let weather = dataProvider.getWeather().first else { return }
        mainInformationView.setupSunriseAndSunsetDate(sunrise: weather.current.sunrise, sunset: weather.current.sunset)
        mainInformationView.setupWindSpeed(with: weather)
        mainInformationView.setupTemperature(with: weather)
        hourlyCollectionView.reloadData()
        everyDayTableView.reloadData()
    }
    
    private func createCollectionViewLoadTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc private func detailsButtonTapped() {
        if let coordinator = coordinator {
            coordinator.pushDetailsViewController(title: navigationItem.title ?? "")
        }
    }
    
    @objc private func openSettings() {
        if let coordinator = coordinator {
            coordinator.pushSettingsViewController()
        }
    }
    
    @objc private func openOnboarding() {
        coordinator?.pushOnboardingViewController()
        //coordinator?.showAlert()
    }
    
    func setupViews() {
        if UserDefaults.standard.bool(forKey: Keys.isCityAdded.rawValue) {
            configureMainInformationView()
            setupEveryDayTableView()
            setupLayout()
            createTimer()
            createCollectionViewLoadTimer()
        } else {
            setupPlusView()
            onPlusViewTapped()
        }
    }
    
    private func onPlusViewTapped() {
        if let coordinator = coordinator {
            plusView.onImageTap = {
                coordinator.showAlert()
            }
        }
    }
    
    //MARK: - Доделать
    private func configureMainInformationView() {
        guard let weather = dataProvider.getWeather().first else { return }
        mainInformationView.configure(with: weather)
        self.navigationItem.title = weather.timezone
        /*NetworkManager.fetchWeather(lat: "55.753215", long: "37.622504") { weather in
            print(weather)
            HourlyWeatherStorage.dailyWeather = weather.daily
            HourlyWeatherStorage.hourlyWeather = weather.hourly
            HourlyWeatherStorage.weather = weather
            //let cityWeather = CityWeather(current: weather.current, timezone: weather.timezone, hourly: weather.hourly, daily: weather.daily)
            /*let realm = self.dataProvider.getWeather()
            if realm.isEmpty {
                self.dataProvider.addWeather(cityWeather)
            } else {
                DispatchQueue.main.async {
                    self.mainInformationView.configure(with: realm.first!)
                    self.navigationItem.title = weather.timezone
                }
            }*/
            DispatchQueue.main.async {
                
            }
            
        }*/
//        NetworkManager.jsonDecodeWeather { weather in
//            //let weather = WeatherData(current: weather.current, timezone: weather.timezone, daily: weather.daily, hourly: weather.hourly)
//            HourlyWeatherStorage.hourlyWeather = weather.hourly
//            HourlyWeatherStorage.dailyWeather = weather.daily
////            for hour in weather.hourly {
////                HourlyWeatherStorage.weather.append(hour)
////            }
//            DispatchQueue.main.async {
//                self.mainInformationView.configure(with: weather)
//                self.navigationItem.title = weather.timezone
//            }
//        }
    }
    
    private func setupEveryDayTableView() {
        everyDayTableView.backgroundColor = .white
        everyDayTableView.dataSource = self
        everyDayTableView.delegate = self
        everyDayTableView.showsVerticalScrollIndicator = false
        everyDayTableView.separatorStyle = .none
        everyDayTableView.register(EveryDayTableViewCell.self, forCellReuseIdentifier: everyDayReuseID)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        let settingsButtonImage = UIImage(named: "burger")
        let cityButtonImage = UIImage(named: "addCity")
        
        let settingsButton = UIBarButtonItem(image: settingsButtonImage, style: .plain, target: self, action: #selector(openSettings))
        let cityButton = UIBarButtonItem(image: cityButtonImage, style: .plain, target: self, action: #selector(openOnboarding))
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = cityButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setupLayout() {
        
        view.addSubviews(mainInformationView, detailsButton, hourlyCollectionView, everyDayLabel, everyDayTableView)

        let constraints = [
            mainInformationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            mainInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            mainInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            mainInformationView.heightAnchor.constraint(equalToConstant: 215),
            
            detailsButton.topAnchor.constraint(equalTo: mainInformationView.bottomAnchor, constant: 30),
            detailsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            hourlyCollectionView.topAnchor.constraint(equalTo: detailsButton.bottomAnchor),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 103),
            
            everyDayLabel.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor),
            everyDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            everyDayTableView.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor),
            everyDayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            everyDayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            everyDayTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupPlusView() {
        
        view.addSubviews(plusView)

        let constraints = [
            plusView.topAnchor.constraint(equalTo: view.topAnchor),
            plusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            plusView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let weather = dataProvider.getWeather()
        return weather.first?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCollectionViewCell.self), for: indexPath) as! HourlyCollectionViewCell
        
        let weather = dataProvider.getWeather()
        guard let current: CachedCurrent = weather.first?.hourly[indexPath.item] else { return UICollectionViewCell() }

        cell.configure(with: current)
        cell.configureUnselectedItem()
        
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 42, height: 83)
    }
    
    //MARK: - Доделать
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HourlyCollectionViewCell
        if cell.isSelected {
            cell.configureSelectedItem()
        }
        guard let index = collectionView.indexPath(for: cell)?.row else { return }
        guard let weather = dataProvider.getWeather().first?.hourly else { return }
        mainInformationView.update(with: weather[index])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HourlyCollectionViewCell {
            if !cell.isSelected {
                cell.configureUnselectedItem()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

extension WeatherViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.getWeather().first?.daily.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let everyDayCell: EveryDayTableViewCell = tableView.dequeueReusableCell(withIdentifier: everyDayReuseID, for: indexPath) as! EveryDayTableViewCell
        
        let weather = dataProvider.getWeather()
        guard let daily: CachedDaily = weather.first?.daily[indexPath.section] else { return UITableViewCell() }
        everyDayCell.configure(with: daily)
        
        return everyDayCell
    }


}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weather = dataProvider.getWeather()
        guard let daily = weather.first?.daily else { return }
        coordinator?.pushDayViewController(day: daily[indexPath.section],
                                           title: navigationItem.title ?? "",
                                           index: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            print(lat, long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
