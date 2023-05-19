//
//  Weather.swift
//  WeatherSizzler
//
//  Created by Tiger Nixon on 5/16/23.
//

import Foundation
import UIKit

struct Weather {
    let id: Int = 0
    let city: String
    let lat: Double
    let lon: Double
    let temp: Double
    let pressure: Double
    let humidity: Double
    let windSpeed: Double
    let windDeg: Double
    let visibility: Double
    let icon: UIImage
    init(response: WeatherResponse, icon: UIImage) {
        self.city = response.name
        self.lat = response.coord.lat
        self.lon = response.coord.lon
        self.temp = response.main.temp
        self.pressure = response.main.pressure
        self.humidity = response.main.humidity
        self.windSpeed = response.wind.speed
        self.windDeg = response.wind.deg
        self.visibility = response.visibility
        self.icon = icon
    }
}

extension Weather: Identifiable {
    
}

extension Weather {
    static var preview: Weather {
        let icon = UIImage(named: "icon_demo") ?? UIImage()
        return Weather(response: WeatherResponse.preview, icon: icon)
    }
}
