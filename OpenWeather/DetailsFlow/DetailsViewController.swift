
import UIKit

class DetailsViewController: UIViewController {
    
    var coordinator: DetailsCoordinator?
    var city: String?
    
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
        let timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
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
        
        view.addSubviews(cityLabel, tableView)
        
        let constraints = [
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            
            /*collectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 36),*/
            
            tableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension DetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HourlyWeatherStorage.hourlyWeather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! DetailsTableViewCell
        
        let weather: Current = HourlyWeatherStorage.hourlyWeather[indexPath.row]
        cell.configure(with: weather)
        
        return cell
    }
}

