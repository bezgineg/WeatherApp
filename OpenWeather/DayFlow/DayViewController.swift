import UIKit

class DayViewController: UIViewController {
    
    var coordinator: DayCoordinator?
    var detailsDay: CachedDaily?
    var city: String?
    var index: Int?
    let dataProvider = RealmDataProvider()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DayCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private var periodsOfTimeReuseID: String {
        return String(describing: PeriodsOfTimeTableViewCell.self)
    }
    
    private var sunAndMoonReuseId: String {
        return String(describing: SunAndMoonTableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        cityLabel.text = city
        setupNavigationBar()
        createTimer()
        createCollectionViewLoadTimer()
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
    
    private func createTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc private func updateData() {
        //collectionView.reloadData()
        tableView.reloadData()
    }
    
    private func createCollectionViewLoadTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Дневная погода"
        let backButtonImage = UIImage(systemName: "arrow.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backToWeather))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .gray
        
    }
    
    @objc private func backToWeather() {
        coordinator?.closeDayViewController()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
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
        guard let weather = dataProvider.getWeather().first else { return 0 }
        return weather.daily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DayCollectionViewCell.self), for: indexPath) as! DayCollectionViewCell
        
        guard let weather = dataProvider.getWeather().first else { return UICollectionViewCell() }
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
        if cell.isSelected {
            cell.configureSelectedItem()
        } else {
            cell.configureUnselectedItem()
        }
        guard let index = collectionView.indexPath(for: cell)?.row else { return }
        
        let weather = dataProvider.getWeather()
        detailsDay = weather.first?.daily[index]
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell {
            if !cell.isSelected {
                cell.configureUnselectedItem()
            } else {
                cell.configureSelectedItem()
            }
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
        
        switch indexPath.section {
        case 0:
            let cell: PeriodsOfTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: periodsOfTimeReuseID, for: indexPath) as! PeriodsOfTimeTableViewCell
            guard let detailsDay = detailsDay else { return UITableViewCell() }
            cell.configureDay(with: detailsDay)
            return cell
        case 1:
            let cell: PeriodsOfTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: periodsOfTimeReuseID, for: indexPath) as! PeriodsOfTimeTableViewCell
            guard let detailsDay = detailsDay else { return UITableViewCell() }
            cell.configureNight(with: detailsDay)
            return cell
        case 2:
            let cell: SunAndMoonTableViewCell = tableView.dequeueReusableCell(withIdentifier: sunAndMoonReuseId, for: indexPath) as! SunAndMoonTableViewCell
            guard let detailsDay = detailsDay else { return UITableViewCell() }
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
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
