//
//  ForecastCollectionViewController.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 03.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "ForecastCollectionViewCell"

class ForecastCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let dataManager: DataManager
    let city: City

    lazy var fetchedResultsController: NSFetchedResultsController<Weather> = {
        let request: NSFetchRequest = Weather.fetchRequest()
        let hours = [13, 14, 15]
        let predicate = NSPredicate(format: "hour in %@", hours)
        if let name = city.name {
            request.predicate = NSPredicate(format: "cityForecast.name == %@", name)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "cityForecast.name == %@", name), predicate])
        } else {
            request.predicate = predicate
        }
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 5
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

    init(dataManager: DataManager, city: City) {
        self.dataManager = dataManager
        self.city = city
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: String(describing: ForecastCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: ForecastCollectionViewCell.self))
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(updateForecast), for: .valueChanged)
        
        collectionView.backgroundColor = .white
        title = city.name
        dataManager.getForecast(forCity: city) { (_) in }
    }
    
    @objc func updateForecast() {
        dataManager.getForecast(forCity: city) { (dataManagerError) in
            self.showErrorAlert(withError: dataManagerError)
        }
    }
    
    func showErrorAlert(withError dataManagerError: DataManagerError?) {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            guard let error = dataManagerError,
                let title = error.errorTitleMessage().0,
                let messge = error.errorTitleMessage().1 else { return }
            let alertController = UIAlertController(title: title, message: messge, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .cancel))
            self.present(alertController, animated: true)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastCollectionViewCell.self), for: indexPath)
            as? ForecastCollectionViewCell else { return UICollectionViewCell() }
        
        cell.layer.cornerRadius = 10
        cell.layer.cornerCurve = .continuous
        cell.backgroundColor = .systemFill
        
        let weather = fetchedResultsController.object(at: indexPath)
        let presenter = ForecastWeatherPresenter(view: cell, weather: weather)
        presenter.setData()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((view.bounds.width - 3 * 16 ) / 2)
        let height = 1.56 * width
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ForecastCollectionViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}

protocol ForecastWeatherPresenterProtocol: class {
    init(view: ForecastCollectionViewCell, weather: Weather)
    func setData()
}
