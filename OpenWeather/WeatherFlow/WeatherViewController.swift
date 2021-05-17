
import UIKit

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
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        coordinator?.didFinishWeather()
//    }
    
    private func createTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc private func updateData() {
        configureMainInformationView()
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
    
    private func setupViews() {
        if UserDefaults.standard.bool(forKey: Keys.isCityAdded.rawValue) {
            configureMainInformationView()
            setupEveryDayTableView()
            setupLayout()
            createTimer()
            createCollectionViewLoadTimer()
        } else {
            setupPlusView()
        }
    }
    
    //MARK: - Доделать
    private func configureMainInformationView() {
        NetworkManager.fetchWeather { weather in
            HourlyWeatherStorage.hourlyWeather = weather.hourly
            HourlyWeatherStorage.dailyWeather = weather.daily
            let cityWeather = CityWeather(current: weather.current, timezone: weather.timezone, hourly: weather.hourly)
            self.dataProvider.addWeather(cityWeather)
            print(self.dataProvider.getWeather().count)
            let newW = self.dataProvider.getWeather()
            print(newW)
            DispatchQueue.main.async {
                self.mainInformationView.configure(with: weather)
                self.navigationItem.title = weather.timezone
            }
        }
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
        return HourlyWeatherStorage.hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCollectionViewCell.self), for: indexPath) as! HourlyCollectionViewCell
        
        let weather: Current = HourlyWeatherStorage.hourlyWeather[indexPath.item]

        cell.configure(with: weather)
        
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
        return HourlyWeatherStorage.dailyWeather.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let everyDayCell: EveryDayTableViewCell = tableView.dequeueReusableCell(withIdentifier: everyDayReuseID, for: indexPath) as! EveryDayTableViewCell
        
        let weather: Daily = HourlyWeatherStorage.dailyWeather[indexPath.section]
        everyDayCell.configure(with: weather)
        
        return everyDayCell
    }


}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.pushDayViewController(day: HourlyWeatherStorage.dailyWeather[indexPath.section],
                                           title: navigationItem.title ?? "")
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
