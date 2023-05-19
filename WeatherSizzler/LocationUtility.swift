//
//  LocationManager.swift
//  WeatherSizzler
//
//  Created by Tiger Nixon on 5/16/23.
//

import Foundation
import CoreLocation

protocol LocationManagerObserving: AnyObject {
    func locationReceived(lat: Float, lon: Float)
    func locationFailed()
}

protocol LocationRepresenting {
    var delegate: LocationManagerObserving? { get set }
    func requestLocation()
}

class LocationUtility: NSObject, LocationRepresenting {
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    weak var delegate: LocationManagerObserving?
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationUtility: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            delegate?.locationReceived(lat: Float(lat), lon: Float(lon))
        } else {
            delegate?.locationFailed()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationFailed()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways,
                .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            delegate?.locationFailed()
        }
    }
}
