
import UIKit

class WeatherViewController: UIViewController {

    var coordinator: WeatherCoordinator?
    
    //private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let mainInformationView: MainInformationView = {
        let view = MainInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let plusView: PlusView = {
        let view = PlusView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HourlyCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
//    private var MainInformationReuseID: String {
//        return String(describing: MainInformationTableViewCell.self)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        
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
    }
    
    private func createCollectionViewLoadTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc private func detailsButtonTapped() {
        print("did Tap")
    }
    
    @objc private func openSettings() {
        if let coordinator = coordinator {
            coordinator.pushSettingsViewController()
        }
    }
    
    @objc private func addCity() {
        coordinator?.showAlert()
    }
    
    private func setupViews() {
        if UserDefaults.standard.bool(forKey: Keys.isCityAdded.rawValue) {
            //setupTableView()
            configureMainInformationView()
            setupLayout()
            createTimer()
            createCollectionViewLoadTimer()
        } else {
            setupPlusView()
        }
    }
    
    private func configureMainInformationView() {
        NetworkManager.jsonDecodeWeather { weather in
            let weather = WeatherData(current: weather.current, timezone: weather.timezone, daily: weather.daily, hourly: weather.hourly)
            for hour in weather.hourly {
                HourlyWeatherStorage.weather.append(hour)
            }
            DispatchQueue.main.async {
                self.mainInformationView.configure(with: weather)
                self.navigationItem.title = weather.timezone
            }
        }
    }
    
//    private func setupTableView() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(MainInformationTableViewCell.self, forCellReuseIdentifier: MainInformationReuseID)
//    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        //navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        let settingsButtonImage = UIImage(named: "burger")
        let cityButtonImage = UIImage(named: "addCity")
        
        let settingsButton = UIBarButtonItem(image: settingsButtonImage, style: .plain, target: self, action: #selector(openSettings))
        let cityButton = UIBarButtonItem(image: cityButtonImage, style: .plain, target: self, action: #selector(addCity))
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = cityButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setupTableViewLayout() {
//        view.addSubview(tableView)
//        let constratints = [
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ]
//
//        NSLayoutConstraint.activate(constratints)

    }
    
    private func setupLayout() {
        view.addSubview(mainInformationView)
        view.addSubview(detailsButton)
        view.addSubview(hourlyCollectionView)

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
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 103)
            
            
            
            
            //mainInformationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            //plusView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupPlusView() {
        view.addSubview(plusView)

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
        return HourlyWeatherStorage.weather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCollectionViewCell.self), for: indexPath) as! HourlyCollectionViewCell
        
        let weather: Current = HourlyWeatherStorage.weather[indexPath.item]

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

//extension WeatherViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 0
//        case 2:
//            return 0
//        default:
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let mainInformationCell: MainInformationTableViewCell = tableView.dequeueReusableCell(withIdentifier: MainInformationReuseID, for: indexPath) as! MainInformationTableViewCell
//            return mainInformationCell
//        default:
//            let mainInformationCell: MainInformationTableViewCell = tableView.dequeueReusableCell(withIdentifier: MainInformationReuseID, for: indexPath) as! MainInformationTableViewCell
//            return mainInformationCell
//        }
//    }
//
//
//}
//
//extension WeatherViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch section {
//        case 0:
//            return 0
//        case 1:
//            return 0
//        case 2:
//            return 0
//        default:
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        switch section {
//        case 0:
//            return 0
//        case 1:
//            return 0
//        case 2:
//            return 0
//        default:
//            return 0
//        }
//    }
//}
