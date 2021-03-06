
import UIKit
import RealmSwift

protocol WeatherViewControllerDelegate: AnyObject {
    func addCity()
    func pushDetailsViewController(_ weatherStorage: CityWeather?)
    func pushDayViewController(day: Daily, index: Int, weatherStorage: CityWeather?)
    func changeTitle(title: String)
}

class WeatherViewController: UIViewController {

    weak var delegate: WeatherViewControllerDelegate?
    var coordinator: WeatherCoordinator?
    var weatherStorage: CityWeather?
    var index: Int?
    
    let weatherDataProvider: WeatherDataProvider
    
    private var storage: StorageService
    private let everyDayTableView = UITableView(frame: .zero, style: .plain)
    
    private var everyDayReuseID: String {
        return String(describing: EveryDayTableViewCell.self)
    }
    
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
        button.setTitleColor(Colors.primaryTextBlackColor, for: .normal)
        button.setTitle("Подробнее на 24 часа", for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = Colors.zeroAlphaButtonColor
        button.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
        button.underline()
        return button
    }()
    
    private lazy var hourlyCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Colors.primaryBackgroundWhiteColor
        cv.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HourlyCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = false
        return cv
    }()
    
    private let everyDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextBlackColor
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Ежедневный прогноз"
        return label
    }()
    
    init(
        weatherStorage: CityWeather?,
        index: Int?,
        weatherDataProvider: WeatherDataProvider,
        storage: StorageService = UserDefaultStorage.shared
    ) {
        self.weatherStorage = weatherStorage
        self.index = index
        self.weatherDataProvider = weatherDataProvider
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.primaryBackgroundWhiteColor
        weatherDataProvider.changeWeatherDelegate = self
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        delegate?.changeTitle(title: weatherStorage?.timezone ?? "")
    }
    
    private func updateViews() {
        if storage.isCityAdded {
            if storage.isFirstAppearance {
                removePlusView()
                setupViews()
                storage.isFirstAppearance = false
            }
            guard let weather = weatherStorage else { return }
            mainInformationView.setupDate()
            mainInformationView.setupSunriseAndSunsetDate(
                sunrise: weather.current.sunrise ?? 0,
                sunset: weather.current.sunset ?? 0
            )
            mainInformationView.setupWindSpeed(with: weather)
            mainInformationView.setupTemperature(with: weather)
            hourlyCollectionView.reloadData()
            everyDayTableView.reloadData()
        }
    }
    
    @objc private func detailsButtonTapped() {
        if let delegate = delegate {
            Storage.newIndex = index
            delegate.pushDetailsViewController(weatherStorage)
        }
    }
    
    private func configureMainInformationView(_ weatherStorage: CityWeather?) {
        guard let weather = weatherStorage else { return }
        mainInformationView.configure(with: weather)
    }
    
    private func onPlusViewTapped() {
        if let delegate = delegate {
            plusView.onImageTap = {
                delegate.addCity()
            }
        }
    }
    
    func removePlusView() {
        plusView.removeFromSuperview()
    }
    
    func setupViews() {
        if storage.isCityAdded {
            configureMainInformationView(weatherStorage)
            setupEveryDayTableView()
            setupLayout()
            storage.isFirstAppearance = false
        } else {
            setupPlusView()
            onPlusViewTapped()
            storage.isFirstAppearance = true
        }
    }
    
    private func setupEveryDayTableView() {
        everyDayTableView.backgroundColor = Colors.primaryBackgroundWhiteColor
        everyDayTableView.dataSource = self
        everyDayTableView.delegate = self
        everyDayTableView.showsVerticalScrollIndicator = false
        everyDayTableView.separatorStyle = .none
        everyDayTableView.register(EveryDayTableViewCell.self, forCellReuseIdentifier: everyDayReuseID)
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

        guard let weather = weatherStorage else { return 0 }
        return weather.hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let weather = weatherStorage else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyCollectionViewCell.self), for: indexPath) as! HourlyCollectionViewCell
        
        let current: Current = weather.hourly[indexPath.item]
        
        cell.storage = storage
        cell.configure(with: current)
        cell.configureUnselectedItem()
        
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 42, height: 83)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! HourlyCollectionViewCell
        
        guard let index = collectionView.indexPath(for: cell)?.row,
              let weather = weatherStorage else { return }

        if cell.isSelected {
            cell.configureSelectedItem()
        }
        mainInformationView.update(with: weather.hourly[index])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HourlyCollectionViewCell else { return }
            
        if !cell.isSelected {
            cell.configureUnselectedItem()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

extension WeatherViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let weather = weatherStorage else { return 0 }
        return weather.daily.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let weather = weatherStorage else { return UITableViewCell() }
        
        let everyDayCell: EveryDayTableViewCell = tableView.dequeueReusableCell(withIdentifier: everyDayReuseID, for: indexPath) as! EveryDayTableViewCell
        
        let daily: Daily = weather.daily[indexPath.section]
        everyDayCell.storage = storage
        everyDayCell.configure(with: daily)
        return everyDayCell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weather = weatherStorage else { return }
        let daily = weather.daily
        Storage.newIndex = index
        delegate?.pushDayViewController(day: daily[indexPath.section],
                                        index: indexPath.section, weatherStorage: weatherStorage)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Colors.primaryBackgroundWhiteColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension WeatherViewController: ChangeWeatherDelegate {
    func weatherDidChange() {
        guard let index = index else { return }
        weatherStorage = weatherDataProvider.getWeather()[index]
        configureMainInformationView(weatherStorage)
        hourlyCollectionView.reloadData()
        everyDayTableView.reloadData()
    }
}


