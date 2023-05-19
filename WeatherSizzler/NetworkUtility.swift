//
//  NetworkManager.swift
//  WeatherSizzler
//
//  Created by Tiger Nixon on 5/16/23.
//

import Foundation
import UIKit

protocol NetworkRepresenting {
    func downloadWeather(q: String) async throws -> Weather
    func downloadWeather(lat: Float, lon: Float) async throws -> Weather
}

struct NetworkUtility: NetworkRepresenting {
    
    private var jsonDecoder: JSONDecoder {
        let result = JSONDecoder()
        result.keyDecodingStrategy = .convertFromSnakeCase
        return result
    }
    
    func downloadWeather(q: String) async throws -> Weather {
        let escaped = q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? q
        let url = "https://api.openweathermap.org/data/2.5/weather?appid=af6d243b5ed97272bd42dd51fd2a1aeb&q=\(escaped)"
        let data = try await download(url: url)
        let response = try jsonDecoder.decode(WeatherResponse.self, from: data)
        return await weather(response: response)
    }
    
    func downloadWeather(lat: Float, lon: Float) async throws -> Weather {
        let url = "https://api.openweathermap.org/data/2.5/weather?appid=af6d243b5ed97272bd42dd51fd2a1aeb&lat=\(lat)&lon=\(lon)"
        let data = try await download(url: url)
        let response = try jsonDecoder.decode(WeatherResponse.self, from: data)
        return await weather(response: response)
    }
    
    private func weather(response: WeatherResponse) async -> Weather {
        var image: UIImage?
        for weather in response.weather where image === nil {
            do {
                let icon = try await downloadIcon(name: weather.icon)
                image = icon
            } catch {
                print(error.localizedDescription)
            }
        }
        if image === nil {
            image = UIImage(named: "icon_demo")
        }
        return Weather(response: response, icon: image!)
    }
    
    private func downloadIcon(name: String) async throws -> UIImage {
        let url = "https://openweathermap.org/img/wn/\(name)@2x.png"
        let data = try await download(url: url)
        guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
        return image
    }
    
    private func download(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
