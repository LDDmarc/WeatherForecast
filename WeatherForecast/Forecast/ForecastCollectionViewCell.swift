//
//  ForecastCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 03.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    var date: Date? {
        didSet {
            guard let date = date else {
                return
            }
            dateLabel.text = DateFormatter.dateDateFormatter().string(from: date)
            timeLabel.text = DateFormatter.timeDateFormatter().string(from: date)
        }
    }

    var currentTemperature: Double? {
        didSet {
            guard let temperature = currentTemperature else {
                return
            }
            let temperatureInt = Int(round(temperature))
            temperatureLabel.text = "\(temperatureInt) °C"
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
            windSpeedLabel.text = "\(round(speed)) м/с"
        }
    }

    var humidity: Double? {
        didSet {
            guard let humidity = humidity else {
                return
            }
            humidityLabel.text = "\(Int(round(humidity))) %"
        }
    }

    var pressure: Double? {
        didSet {
            guard let pressure = pressure else {
                return
            }
            pressureLabel.text = "\(Int(round(pressure/1.333))) мм рт.ст."
        }
    }

    var iconName: String? {
        didSet {
            guard let icon = iconName else { return }
            iconImageView.sd_setImage(with: URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
