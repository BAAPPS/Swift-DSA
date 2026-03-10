//
//  OpenWeatherAPI.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import Foundation

enum OpenWeatherAPIEndpoint: APIEndpoint {
    case forecast(lat: Double, lon: Double)
    case geo(city: String)
    
    
    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String ?? ""
    }
    
    
    var scheme: String { "https" }

    var host: String { "api.openweathermap.org" }

    var path: String {
        switch self {
        case .forecast:
            return "/data/2.5/forecast"
        case .geo:
            return "/geo/1.0/direct"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .forecast(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "imperial"),
                URLQueryItem(name: "lang", value: "en")
            ]
        case .geo(let city):
            return [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: apiKey)
            ]
        }
    }
}
