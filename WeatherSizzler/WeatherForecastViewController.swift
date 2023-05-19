//
//  ViewController.swift
//  WeatherSizzler
//
//  Created by Tiger Nixon on 5/16/23.
//

import UIKit
import SwiftUI

class WeatherForecastViewController: UIViewController {

    let weatherForecastViewHostingController: UIHostingController<WeatherForecastView>
    let weatherContext: WeatherContext
    required init(weatherContext: WeatherContext) {
        self.weatherContext = weatherContext
        self.weatherForecastViewHostingController = UIHostingController(rootView: WeatherForecastView(weatherContext: weatherContext))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selfView = self.view, let hostingControllerView = weatherForecastViewHostingController.view {
            hostingControllerView.translatesAutoresizingMaskIntoConstraints = false
            selfView.addSubview(hostingControllerView)
            selfView.addConstraints([
                hostingControllerView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor),
                hostingControllerView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor),
                hostingControllerView.topAnchor.constraint(equalTo: selfView.safeAreaLayoutGuide.topAnchor),
                hostingControllerView.bottomAnchor.constraint(equalTo: selfView.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}
