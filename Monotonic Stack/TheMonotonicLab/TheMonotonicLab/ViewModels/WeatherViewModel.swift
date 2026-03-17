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
    
    // MARK: - New property for next greater / smaller day
    var nextGreaterDays: [TemperatureResult] = []
    var nextSmallerDays: [TemperatureResult] = []
    
    
    
    // MARK: - Computed
    var currentTemperature: String {
        guard let temp = weather?.list.first?.main.temp else {return "--"}
        return "\(Int(temp))\(temperatureUnit)"
    }
    
    var allTemperatures: [Double] {
        return weather?.list.map {$0.main.temp} ?? []
    }
    
    var tempInts: [Int] {
        return allTemperatures.map { Int($0) }
    }
    

    // MARK: - API Call
    func loadWeather() async {
        isLoading = true
        errorMessage = nil
        
        print("🌤️ Starting fetch for city: \(city)")
        
        do {
            let fetchedWeather = try await OpenWeatherAPIManager.shared.fetchForecast(for: city)
            weather = fetchedWeather
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            print("✅ Fetched weather: \(fetchedWeather.list.first?.main.temp ?? 0)°")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error fetching weather: \(error.localizedDescription)")
        }
        
        isLoading = false
        print("🌤️ Finished fetch for city: \(city)")
    }
    
    // MARK: - Compute Greater / Smaller Temperature Days
    
    func computeNextGreaterDays() {
        nextGreaterDays = TemperatureDay.findGreaterTemperatureDay(tempInts)
    }
    
    func computeNextSmallerDays() {
        nextSmallerDays = TemperatureDay.findSmallerTemperatureDay(tempInts)
    }
    
    // MARK: - Day String Formatter
    
    func formatDays(_ days: Int) -> String {
        if days == -1 {
            return "N/A" // or "No data"
        } else {
            return "\(days) \(days == 1 ? "Day" : "Days")"
        }
    }
    
}

// MARK: - Preview Data
extension WeatherViewModel {
    static var preview: WeatherViewModel {
        let vm = WeatherViewModel()
        
        vm.nextGreaterDays = [
            TemperatureResult(days: 1, previousValue: 68, nextValue: 70),
            TemperatureResult(days: 2, previousValue: 70, nextValue: 72),
            TemperatureResult(days: -1, previousValue: -1, nextValue: -1),
            TemperatureResult(days: 1, previousValue: 67, nextValue: 68),
            TemperatureResult(days: 3, previousValue: 68, nextValue: 71)
        ]
        
        vm.nextSmallerDays = [
            TemperatureResult(days: 2, previousValue: 67, nextValue: 65),
            TemperatureResult(days: 5, previousValue: 65, nextValue: 60),
            TemperatureResult(days: 1, previousValue: 64, nextValue: 64),
            TemperatureResult(days: 2, previousValue: 65, nextValue: 63),
            TemperatureResult(days: 1, previousValue: 63, nextValue: 62)
        ]
        
        return vm
    }
}
