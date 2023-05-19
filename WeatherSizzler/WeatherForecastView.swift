//
//  WeatherForecastView.swift
//  WeatherSizzler
//
//  Created by Tiger Nixon on 5/16/23.
//

import SwiftUI
import MapKit

struct WeatherForecastView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @ObservedObject var weatherContext: WeatherContext
    @State var searchText: String
    
    init(weatherContext: WeatherContext) {
        self.weatherContext = weatherContext
        _searchText = State(wrappedValue: weatherContext.searchText)
    }
    
    var body: some View {
        VStack {
            searchBarRow()
                .padding(.top, 12.0)
                .onChange(of: searchText) { _ in
                    Task {
                        await weatherContext.updateSearchTextIntent(searchText)
                    }
                }
            
            if let weather = weatherContext.weather {
                GeometryReader { geometry in
                    if verticalSizeClass == .compact {
                        // Landscape on iPhone
                        mainContentWide(weather: weather,
                                        geometry: geometry)
                    } else {
                        // Portrait on iPhone
                        // iPad
                        mainContentTall(weather: weather,
                                        geometry: geometry)
                    }
                }
            } else {
                loadingView()
            }
        }
    }
    
    func searchBarRow() -> some View {
        HStack {
            HStack(spacing: 0.0) {
                TextField("City", text: $searchText)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .padding(.vertical, 6)
                    .padding(.leading, 12)
                    .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.35))
                Button {
                    Task {
                        await weatherContext.requestLocation()
                    }
                } label: {
                    ZStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.35))
                            .font(.system(size: 22.0))
                    }
                    .frame(width: 44.0, height: 44.0)
                }
            }
            .background(RoundedRectangle(cornerRadius: 8.0).foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.92)))
        }
        .padding(.horizontal, 24.0)
    }
    
    func mainContentTall(weather: Weather, geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(spacing: 0.0) {
                titleAndIconRow(weather: weather)
                dataRow(weather: weather)
                mapRow(weather: weather)
            }
        }
    }
    
    func mainContentWide(weather: Weather, geometry: GeometryProxy) -> some View {
        let leftWidth = CGFloat(Int(geometry.size.width / 2.0 + 0.5))
        let rightWidth = geometry.size.width - leftWidth
        return HStack(spacing: 0.0) {
            VStack(spacing: 0.0) {
                ScrollView {
                    titleAndIconRow(weather: weather)
                    dataRow(weather: weather)
                }
            }
            .frame(width: leftWidth)
            VStack {
                mapRow(weather: weather)
            }
            .frame(width: rightWidth)
        }
    }
    
    func titleAndIconRow(weather: Weather) -> some View {
        VStack(spacing: 0.0) {
            HStack {
                Spacer()
                Text(weather.city)
                    .font(.system(size: 26.0).bold())
                    .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.35))
                Spacer()
            }
            .padding(.horizontal, 24.0)
            Image(uiImage: weather.icon)
                .padding(.bottom, -12.0)
                .padding(.top, -12.0)
            
            HStack {
                Spacer()
                Text(weatherContext.temperatureString(weather: weather))
                    .font(.system(size: 26.0).bold())
                    .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.35))
                Spacer()
            }
            .padding(.bottom, 12.0)
            
            HStack {
                Spacer()
            }
            .frame(height: 1.0)
            .background(Color(red: 0.35, green: 0.55, blue: 0.35))
        }
        .background()
    }
    
    func dataRow(weather: Weather) -> some View {
        VStack(spacing: 0.0) {
            VStack(spacing: 0.0) {
                dataRowField(title: "Humidity",
                             value: weatherContext.humidityString(weather: weather), even: true)
                dataRowField(title: "Wind Speed",
                             value: weatherContext.windSpeedString(weather: weather), even: false)
                dataRowField(title: "Wind Degrees",
                             value: weatherContext.windDegreeString(weather: weather), even: true)
                dataRowField(title: "Pressure",
                             value: weatherContext.pressureString(weather: weather), even: false)
                dataRowField(title: "Visibility",
                             value: weatherContext.visibilityString(weather: weather), even: true)
            }
            .padding(.vertical, 6.0)
            
            if verticalSizeClass != .compact {
                HStack {
                    Spacer()
                }
                .frame(height: 1.0)
                .background(Color(red: 0.35, green: 0.55, blue: 0.35))
            }
        }
    }
    
    func dataRowField(title: String, value: String, even: Bool) -> some View {
        HStack {
            Text("\(title): \(value)")
                .font(.system(size: 18.0).bold())
                .foregroundColor(Color(red: 0.35, green: 0.55, blue: 0.35))
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.horizontal, 24.0)
        .padding(.vertical, 6.0)
        .background(even ? Color.white : Color(red: 0.92, green: 0.92, blue: 0.92))
    }
    
    func mapRow(weather: Weather) -> some View {
        MapViewRepresentable(coordinateRegion: weatherContext.coordinateRegion)
            .frame(minHeight: 256.0, idealHeight: 480.0, maxHeight: 768.0)
    }
    
    func loadingView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color(red: 0.35, green: 0.55, blue: 0.35))
                        .scaleEffect(1.5)
                }
                .frame(width: 80.0, height: 80.0)
                .background(RoundedRectangle(cornerRadius: 12.0).foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.92)))
                Spacer()
            }
            Spacer()
        }
        .background(Color.white)
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView(weatherContext: WeatherContext.preview)
    }
}
