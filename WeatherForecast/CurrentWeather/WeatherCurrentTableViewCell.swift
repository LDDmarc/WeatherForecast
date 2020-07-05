//
//  WeatherCurrentTableViewCell.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class WeatherCurrentTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    
    var cityName: String? {
        didSet {
            cityNameLabel.text = cityName
        }
    }
    var date: Date? {
        didSet {
            guard let time = date else { return }
            timeLabel.text = DateFormatter.timeDateFormatter().string(from: time)
        }
    }
    var currentTemperature: Double? {
        didSet {
            guard let temperature = currentTemperature else {
                return
            }
            let temperatureInt = Int(round(temperature))
            currentTemperatureLabel.text = "\(temperatureInt)"
        }
    }
    var minTemperature: Double? {
        didSet {
            guard let temperature = minTemperature else {
                return
            }
            let temperatureInt = Int(round(temperature))
            minTemperatureLabel.text = "\(temperatureInt)"
        }
    }
    var maxTemperature: Double? {
        didSet {
            guard let temperature = maxTemperature else {
                return
            }
            let temperatureInt = Int(round(temperature))
            maxTemperatureLabel.text = "\(temperatureInt)"
        }
    }
    var windSpeed: Double? {
        didSet {
            guard let speed = windSpeed else {
                return
            }
            windSpeedLabel.text = "\(round(10 * speed) / 10) м/с"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
