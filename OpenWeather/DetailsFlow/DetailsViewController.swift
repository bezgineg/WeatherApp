
import UIKit

class DetailsViewController: UIViewController {
    
    var coordinator: DetailsCoordinator?
    var city: String?
    var weatherStorage: CityWeather?
    
    private var storage: StorageService
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var reuseID: String {
        return String(describing: DetailsTableViewCell.self)
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
        cv.backgroundColor = Colors.customBackgroundColor
        cv.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DetailsCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    init(
        weatherStorage: CityWeather?,
        storage: StorageService = UserDefaultStorage.shared
    ) {
        self.weatherStorage = weatherStorage
        self.storage = storage
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.didFinishDetails()
    }
    
    @objc private func backToWeather() {
        coordinator?.closeDetailsViewController()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Прогноз на 24 часа"
        let backButtonImage = UIImage(systemName: "arrow.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backToWeather))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = Colors.imageTintGrayColor
        
    }
    
    private func setupTableView() {
        tableView.backgroundColor = Colors.primaryBackgroundWhiteColor
        tableView.dataSource = self
        tableView.separatorColor = Colors.dividerColor
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: reuseID)
    }
    
    private func setupLayout() {
        
        view.addSubviews(cityLabel, collectionView, tableView)
        
        let constraints = [
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            
            collectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 160),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension DetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailsCollectionViewCell.self), for: indexPath) as! DetailsCollectionViewCell
        cell.storage = storage
        
        return cell
    }
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 2000, height: 160)
    }
}

extension DetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weather = weatherStorage else { return 0 }
        
        return weather.hourly.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let weather = weatherStorage else { return UITableViewCell() }
        
        let cell: DetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! DetailsTableViewCell
        
        let current: Current = weather.hourly[indexPath.row]
        cell.configure(with: current)
        cell.storage = storage
        
        return cell
    }
}

