
import UIKit

class WeatherViewController: UIViewController {

    var coordinator: WeatherCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupLayout()
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        coordinator?.didFinishWeather()
//    }
    
    @objc private func openSettings() {
        print("1")
    }
    
    @objc private func addCity() {
        print("2")
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
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
    
    private func setupLayout() {
//        view.addSubview(settingsView)
//
//        let constraints = [
//            settingsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            settingsView.heightAnchor.constraint(equalToConstant: 330)
//        ]
//        NSLayoutConstraint.activate(constraints)
    }

}

