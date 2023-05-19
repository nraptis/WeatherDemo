//
//  WeatherContext.swift
//  WeatherSizzler
//
//  Created by Tiger Nixon on 5/16/23.
//

import Foundation
import MapKit

actor WeatherContext: ObservableObject {
    
    @MainActor @Published var searchText = "El Segundo"
    @MainActor @Published var weather: Weather?
    @MainActor @Published var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), latitudinalMeters: 0.0225, longitudinalMeters: 0.0225)
    
    var loc: LocationRepresenting
    var net: NetworkRepresenting
    init(net: NetworkRepresenting, loc: LocationRepresenting) {
        self.net = net
        self.loc = loc
        Task {
            await updateSearchTextIntent(searchText)
        }
    }
    
    @MainActor func requestLocation() async {
        Task {
            await loc.delegate = self
            await loc.requestLocation()
        }
    }
    
    @MainActor var isDoingSearchFetch = false
    @MainActor private var _shouldDoAdditionalSearchFetch = false
    @MainActor func updateSearchTextIntent(_ searchText: String) async {
        self.searchText = searchText
        if isDoingSearchFetch {
            _shouldDoAdditionalSearchFetch = true
            return
        }
        isDoingSearchFetch = true
        
        do {
            let _weather = try await net.downloadWeather(q: searchText)
            set(weather: _weather)
        } catch {
            print(error.localizedDescription)
        }
        isDoingSearchFetch = false
        if _shouldDoAdditionalSearchFetch {
            _shouldDoAdditionalSearchFetch = false
            await updateSearchTextIntent(self.searchText)
        }
    }
    
    @MainActor var isDoingGeoFetch = false
    @MainActor private func updateLocation(lat: Float, lon: Float) async {
        isDoingGeoFetch = true
        Task {
            do {
                let _weather = try await net.downloadWeather(lat: lat, lon: lon)
                set(weather: _weather)
            } catch {
                print(error.localizedDescription)
                isDoingGeoFetch = false
                return
            }
            isDoingGeoFetch = false
        }
    }
    
    @MainActor func set(weather: Weather) {
        self.weather = weather
        let location = CLLocationCoordinate2D(latitude: weather.lat,
                                              longitude: weather.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.0225,
                                    longitudeDelta: 0.0225)
        self.coordinateRegion = MKCoordinateRegion(center: location,
                                                   span: span)
    }
}

extension WeatherContext {
    nonisolated func humidityString(weather: Weather) -> String {
        String(format: "%.2f%%", weather.humidity)
    }
    
    nonisolated func windSpeedString(weather: Weather) -> String {
        String(format: "%.2f m/s", weather.windSpeed)
    }
    
    nonisolated func windDegreeString(weather: Weather) -> String {
        String(format: "%.2fº", weather.windDeg)
    }
    
    nonisolated func visibilityString(weather: Weather) -> String {
        String(format: "%.2f m", weather.visibility)
    }
    
    nonisolated func temperatureString(weather: Weather) -> String {
        String(format: "%.2fºC", kelvinToCelsius(weather.temp))
    }
    
    nonisolated func pressureString(weather: Weather) -> String {
        String(format: "%.2f hPa", weather.pressure)
    }
    
    nonisolated private func kelvinToCelsius(_ kelvin: Double) -> Double {
        kelvin - 273.15
    }
}

extension WeatherContext: LocationManagerObserving {
    nonisolated func locationReceived(lat: Float, lon: Float) {
        Task {
            await updateLocation(lat: lat, lon: lon)
        }
    }
    
    nonisolated func locationFailed() {
        
    }
}

extension WeatherContext {
    @MainActor static var preview: WeatherContext {
        let net = NetworkUtility()
        let loc = LocationUtility()
        let result = WeatherContext(net: net, loc: loc)
        result.weather = Weather.preview
        return result
    }
}
