import UIKit

class DayViewController: UIViewController {
    
    var coordinator: DayCoordinator?
    var detailsDay: CachedDaily?
    var city: String?
    var index: Int?
    var weatherStorage: CityWeatherCached?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var periodsOfTimeReuseID: String {
        return String(describing: PeriodsOfTimeTableViewCell.self)
    }
    
    private var sunAndMoonReuseId: String {
        return String(describing: SunAndMoonTableViewCell.self)
    }
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryTextBlackColor
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Colors.primaryBackgroundWhiteColor
        cv.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DayCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = false
        return cv
    }()
    
    init(weatherStorage: CityWeatherCached?) {
        self.weatherStorage = weatherStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.primaryBackgroundWhiteColor
        cityLabel.text = city
        setupNavigationBar()
        setupTableView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.didFinishDay()
    }
    
    private func setupCollectionView() {
        guard let index = index else { return }
        if index >= 4 {
        let selectedIndex = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: selectedIndex, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .centeredHorizontally)
        }
        else {
            let selectedIndex = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: selectedIndex, at: UICollectionView.ScrollPosition.left, animated: true)
            collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .left)
        }
    }
    
    @objc private func backToWeather() {
        coordinator?.closeDayViewController()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Дневная погода"
        let backButtonImage = UIImage(systemName: "arrow.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backToWeather))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = Colors.imageTintGrayColor
        
    }
    
    private func setupTableView() {
        tableView.backgroundColor = Colors.primaryBackgroundWhiteColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(PeriodsOfTimeTableViewCell.self, forCellReuseIdentifier: periodsOfTimeReuseID)
        tableView.register(SunAndMoonTableViewCell.self, forCellReuseIdentifier: sunAndMoonReuseId)
    }
    
    private func setupLayout() {
        
        view.addSubviews(cityLabel, collectionView, tableView)
        
        let constraints = [
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            collectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension DayViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weather = weatherStorage else { return 0 }
        return weather.daily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let weather = weatherStorage else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DayCollectionViewCell.self), for: indexPath) as! DayCollectionViewCell
        
        let daily: CachedDaily = weather.daily[indexPath.item]
        
        cell.configure(with: daily)
        
        return cell
    }
}

extension DayViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 88, height: 36)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        
        guard let index = collectionView.indexPath(for: cell)?.row else { return }

        if cell.isSelected {
            cell.configureSelectedItem()
        } else {
            cell.configureUnselectedItem()
        }
        
        let weather = weatherStorage
        detailsDay = weather?.daily[index]
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else { return }
        
        if !cell.isSelected {
            cell.configureUnselectedItem()
        } else {
            cell.configureSelectedItem()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

extension DayViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let detailsDay = detailsDay else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            let cell: PeriodsOfTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: periodsOfTimeReuseID, for: indexPath) as! PeriodsOfTimeTableViewCell
            cell.configureDay(with: detailsDay)
            return cell
        case 1:
            let cell: PeriodsOfTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: periodsOfTimeReuseID, for: indexPath) as! PeriodsOfTimeTableViewCell
            cell.configureNight(with: detailsDay)
            return cell
        case 2:
            let cell: SunAndMoonTableViewCell = tableView.dequeueReusableCell(withIdentifier: sunAndMoonReuseId, for: indexPath) as! SunAndMoonTableViewCell
            cell.configure(with: detailsDay)
            return cell
        default:
            return UITableViewCell()
        }
    }

}

extension DayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Colors.primaryBackgroundWhiteColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
