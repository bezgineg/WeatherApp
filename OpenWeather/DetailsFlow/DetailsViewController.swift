
import UIKit

class DetailsViewController: UIViewController {
    
    var coordinator: DetailsCoordinator?
    var city: String?
    
    private let dataProvider = RealmDataProvider()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var reuseID: String {
        return String(describing: DetailsTableViewCell.self)
    }
    
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
        cv.backgroundColor = Colors.customBackgroundColor
        cv.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DetailsCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.didFinishDetails()
    }
    
    private func createTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
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
        // MARK: - Доделать
        navigationItem.title = "Прогноз на 24 часа"
        /*let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]*/
        let backButtonImage = UIImage(systemName: "arrow.left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backToWeather))
        navigationItem.leftBarButtonItem = backButton
        //navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.leftBarButtonItem?.tintColor = .gray
        
    }
    
    @objc private func backToWeather() {
        coordinator?.closeDetailsViewController()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.dataSource = self
        //tableView.delegate = self
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
        
        guard let weather = dataProvider.getWeather().first else { return UICollectionViewCell() }
        let daily: CachedDaily = weather.daily[indexPath.item]

        
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
        guard let weather = dataProvider.getWeather().first else { return 0 }
        
        return weather.hourly.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! DetailsTableViewCell
        
        guard let weather = dataProvider.getWeather().first else { return UITableViewCell() }
        let current: CachedCurrent = weather.hourly[indexPath.row]
        cell.configure(with: current)
        
        return cell
    }
}

