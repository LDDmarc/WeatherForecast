//
//  ForecastWeatherPresenter.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 03.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class ForecastWeatherPresenter: ForecastWeatherPresenterProtocol {

    unowned let view: ForecastCollectionViewCell

    let weather: Weather

    required init(view: ForecastCollectionViewCell, weather: Weather) {
        self.view = view
        self.weather = weather
    }
    
    func setData() {
        view.currentTemperature = weather.temperature
        view.minTemperature = weather.temperatureMin
        view.maxTemperature = weather.temperatureMax
        view.windSpeed = weather.windSpeed
        view.humidity = weather.humidity
        view.pressure = weather.pressure
        view.date = weather.date
        view.iconName = weather.icon
    }
}
