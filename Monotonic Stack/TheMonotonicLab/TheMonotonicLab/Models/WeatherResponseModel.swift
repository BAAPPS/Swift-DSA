//
//  OpenWeatherModel.swift
//  TheMonotonicLab
//
//  Created by D F on 3/9/26.
//

import Foundation

struct WeatherResponseModel: Codable {
    let list: [Forecast]
    let city: City
    
    struct Forecast: Codable {
        let main: Temperature
    }
    
    struct Temperature: Codable {
        let temp: Double
    }
    
    struct City: Codable {
        let name: String
        let coord: Coordinates
        let country: String
        
    }
    
    struct Coordinates: Codable {
        let lat: Double
        let lon: Double
    }
}

