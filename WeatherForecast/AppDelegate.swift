//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let taskIdentifier = "com.darialeonova.fetchWeather"
    let dataManager = DataManager(persistentContainer: CoreDataManager.shared.persistentContainer)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { (task) in
            guard let refreshTask = task as? BGAppRefreshTask else { return }
            self.appRefreshTaskHandler(task: refreshTask)
        }
        return true
    }

    func appRefreshTaskHandler(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            NetworkManager.urlSession.invalidateAndCancel()
        }
        dataManager.getCurrentWeather { (_) in
            task.setTaskCompleted(success: true)
        }
        scheduleBackgroundFetch()
    }

    func scheduleBackgroundFetch() {
        let backgroundFetchTask = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        backgroundFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(backgroundFetchTask)
        } catch {
            print(error.localizedDescription)
        }
    }
}
