//
//  ViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.settingTabBarUI()
    }
    
    private func settingTabBarUI() -> Void {
        
        view.backgroundColor = .systemBackground
        
        let homeVC: UINavigationController = UINavigationController(rootViewController: HomeViewController())
        let upcomingVC: UINavigationController = UINavigationController(rootViewController: UpcomingViewController())
        let searchVC: UINavigationController = UINavigationController(rootViewController: SearchViewController())
        let downloadsVC: UINavigationController = UINavigationController(rootViewController: DownloadsViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.rectangle.on.rectangle")
        upcomingVC.tabBarItem.selectedImage = UIImage(systemName: "play.rectangle.on.rectangle.fill")
        
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        searchVC.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.circle")
        downloadsVC.tabBarItem.selectedImage = UIImage(systemName: "arrow.down.circle.fill")
        
        homeVC.title = "Home"
        upcomingVC.title = "Upcoming"
        searchVC.title = "Search"
        downloadsVC.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, upcomingVC, searchVC, downloadsVC], animated: true)
    }
}

