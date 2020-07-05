//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import CoreLocation

class WeatherTableViewController: UITableViewController {

    let dataManager: DataManager
    var timer: Timer?

    lazy var fetchedResultsController: NSFetchedResultsController<City> = {
        let request: NSFetchRequest = City.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            print(nserror.localizedDescription)
        }
        frc.delegate = self
        return frc
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: String(describing: WeatherCurrentTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: WeatherCurrentTableViewCell.self))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateWeather), for: .valueChanged)
        
        timer = Timer.scheduledTimer(timeInterval: 1800,
                                            target: self,
                                            selector: #selector(updateWeatherByTimer),
                                            userInfo: nil,
                                            repeats: true)
        checkFirstLaunch()
        updateWeatherByTimer()
    }
    
    @objc func updateWeatherByTimer() {
        dataManager.getCurrentWeather { (_) in }
    }
    @objc func updateWeather() {
        dataManager.getCurrentWeather { (dataManagerError) in
            self.showErrorAlert(withError: dataManagerError)
        }
    }

    func checkFirstLaunch() {
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "wasLaunchedBefore")
        if firstLaunch.isFirstLaunch {
            let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
    
    @objc func addCity() {
        let alertController = UIAlertController(title: "Новый город", message: "Введите имя города", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Москва"
        }
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            self.dataManager.addNewCity(withName: textField.text) { (dataManagerError) in
                self.showErrorAlert(withError: dataManagerError)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func showErrorAlert(withError dataManagerError: DataManagerError?) {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            guard let error = dataManagerError,
                let title = error.errorTitleMessage().0,
                let messge = error.errorTitleMessage().1 else { return }
            let alertController = UIAlertController(title: title, message: messge, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alertController, animated: true)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherCurrentTableViewCell.self)) as? WeatherCurrentTableViewCell else {
            return UITableViewCell()
        }
        let city = fetchedResultsController.object(at: indexPath)
        let presenter = CurrentWeatherPresenter(view: cell, city: city)
        presenter.setData()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = fetchedResultsController.object(at: indexPath)
        let viewController = ForecastCollectionViewController(dataManager: dataManager, city: city)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = fetchedResultsController.object(at: indexPath)
            dataManager.context.delete(city)
            try? dataManager.context.save()
        }
    }
}

protocol CurrentWeatherPresenterProtocol: class {
    init(view: WeatherCurrentTableViewCell, city: City)
    func setData()
}
