import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, WeatherViewControllerDelegate {
    
    var coordinator: WeatherCoordinator?
    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    var weather: CityWeatherCached? = nil
    var index: Int? = nil
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupPageController()
    }
    
    func pushDayViewController(day: CachedDaily, index: Int, weatherStorage: CityWeatherCached?) {
        coordinator?.pushDayViewController(day: day,
                                           title: navigationItem.title ?? "",
                                           index: index,
                                           weatherStorage: weatherStorage)
    }
    
    func pushDetailsViewController(_ weatherStorage: CityWeatherCached?) {
        coordinator?.pushDetailsViewController(title: navigationItem.title ?? "", weatherStorage: weatherStorage)
    }
    
    func addCity() {
        coordinator?.showAddCityAlert()
    }
    
    func changeTitle(title: String) {
        navigationItem.title = title
    }
    
    func update() {
        setupPageController()
    }
    
    @objc private func openSettings() {
        coordinator?.pushSettingsViewController()
    }
    
    @objc private func openOnboarding() {
        coordinator?.pushOnboardingViewController()
    }
    
    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self

        addChild(pageController)
        view.addSubview(pageController.view)

        let views = ["pageController": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        controllers.removeAll()
        let weatherStorage = RealmDataProvider.shared.getWeather()
        if weatherStorage.isEmpty {
            let vc = WeatherViewController(weatherStorage: weather, index: index)
            vc.delegate = self
            controllers.append(vc)
        } else {
            for (index, weather) in weatherStorage.enumerated() {
                let vc = WeatherViewController(weatherStorage: weather, index: index)
                vc.delegate = self
                controllers.append(vc)
            }
        }

        pageController.setViewControllers([controllers[Storage.newIndex ?? 0]], direction: .forward, animated: false)
        configurePageControll()
    }
    
    private func configurePageControll() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = controllers.count
        pageControl.currentPage = Storage.newIndex ?? 0
        pageControl.tintColor = Colors.imageTintBlackColor
        pageControl.pageIndicatorTintColor = Colors.imageTintWhiteColor
        pageControl.currentPageIndicatorTintColor = Colors.imageTintBlackColor
        pageControl.hidesForSinglePage = true
        view.addSubview(pageControl)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = Colors.primaryBackgroundWhiteColor
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        let settingsButtonImage = UIImage(named: "burger")
        let cityButtonImage = UIImage(named: "addCity")
        
        let settingsButton = UIBarButtonItem(image: settingsButtonImage, style: .plain, target: self, action: #selector(openSettings))
        let cityButton = UIBarButtonItem(image: cityButtonImage, style: .plain, target: self, action: #selector(openOnboarding))
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = cityButton
        navigationItem.leftBarButtonItem?.tintColor = Colors.imageTintBlackColor
        navigationItem.rightBarButtonItem?.tintColor = Colors.imageTintBlackColor
        if userDefaultStorage.isTrackingBoolKey {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        let pageContentViewController = viewControllers[0]
        
        if let currentIndex = controllers.firstIndex(of: pageContentViewController) {
            pageControl.currentPage = currentIndex
        } else {
            pageControl.currentPage = 0
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        return nil
    }
}
