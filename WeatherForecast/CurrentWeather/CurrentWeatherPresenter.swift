//
//  CurrentWeatherPresenter.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 03.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    unowned let view: WeatherCurrentTableViewCell
    let city: City
    
    required init(view: WeatherCurrentTableViewCell, city: City) {
        self.view = view
        self.city = city
    }
    
    func setData() {
        view.cityName = city.name
        guard let weather = city.currentWeather else {
            return
        }
        view.currentTemperature = weather.temperature
        view.minTemperature = weather.temperatureMin
        view.maxTemperature = weather.temperatureMax
        view.windSpeed = weather.windSpeed
        view.date = weather.date
    }
}
