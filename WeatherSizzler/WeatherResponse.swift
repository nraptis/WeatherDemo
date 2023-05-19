//
//  WeatherResponse.swift
//  WeatherSizzler
//
//  Created by Nick Raptis on 5/16/23.
//

import Foundation
import UIKit

public struct WeatherResponse: Decodable {
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    let coord: Coord
    
    struct Main: Decodable {
        let temp: Double
        let pressure: Double
        let humidity: Double
    }
    let main: Main
    let name: String
    
    struct Weather: Decodable {
        let icon: String
    }
    let weather: [Weather]
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Double
    }
    let wind: Wind
    let visibility: Double
}

extension WeatherResponse {
    static var preview: WeatherResponse {
        WeatherResponse(coord: .init(lon: -118.4165, lat: 33.9192),
                        main: .init(temp: 287.98, pressure: 1016.0, humidity: 95.0),
                        name: "El Segundo",
                        weather: [.init(icon: "50d")],
                        wind: .init(speed: 2.57, deg: 240.0),
                        visibility: 4828.0)
    }
}
