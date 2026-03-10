//
//  WeatherViewModel.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import Foundation

@Observable
final class WeatherViewModel {
    var weather: WeatherResponseModel?
    var isLoading = false
    var errorMessage: String?
    var temperatureUnit: String = "°F"
    var city: String = "San Francisco"

    // MARK: - Computed
    var currentTemperature: String {
        guard let temp = weather?.list.first?.main.temp else {return "--"}
        return "\(Int(temp))\(temperatureUnit)"
    }
    
    var allTemperatures: [Double] {
        return weather?.list.map {$0.main.temp} ?? []
    }
    
    // MARK: - API Call
    func loadWeather() async {
        isLoading = true
        errorMessage = nil
        
        print("🌤️ Starting fetch for city: \(city)")
        
        do {
            let fetchedWeather = try await OpenWeatherAPIManager.shared.fetchForecast(for: city)
            weather = fetchedWeather
            print("✅ Fetched weather: \(fetchedWeather.list.first?.main.temp ?? 0)°")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error fetching weather: \(error.localizedDescription)")
        }
        
        isLoading = false
        print("🌤️ Finished fetch for city: \(city)")
    }
}
