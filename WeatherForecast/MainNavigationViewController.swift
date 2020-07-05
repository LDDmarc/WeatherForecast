//
//  MainNavigationViewController.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 03.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataManager = DataManager(persistentContainer: CoreDataManager.shared.persistentContainer)
        let currentWeatherViewController = WeatherTableViewController(dataManager: dataManager)
        currentWeatherViewController.title = "Погода"
        navigationBar.prefersLargeTitles = true
        self.viewControllers = [currentWeatherViewController]
    }
}
