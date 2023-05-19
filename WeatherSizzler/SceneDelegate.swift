//
//  SceneDelegate.swift
//  WeatherSizzler
//
//  Created by Tiger Nixon on 5/16/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    lazy var net: NetworkUtility = {
        NetworkUtility()
    }()
    
    lazy var loc: LocationUtility = {
        LocationUtility()
    }()
    
    lazy var weatherContext: WeatherContext = {
        WeatherContext(net: net, loc: loc)
    }()
    
    lazy var weatherForecastViewController: WeatherForecastViewController = {
        WeatherForecastViewController(weatherContext: weatherContext)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let windowScene = scene as! UIWindowScene
        window = UIWindow(windowScene: windowScene)
        window!.rootViewController = weatherForecastViewController
        window!.makeKeyAndVisible()
    }
}

