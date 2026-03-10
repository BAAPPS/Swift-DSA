//
//  OpenWeatherAPIManager.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import Foundation

// MARK: - OpenWeather API Errors
enum OpenWeatherAPIError: Error, LocalizedError {
    case noLocationFound
    case networkError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .noLocationFound:
            return "No location found for the city."
        case .networkError(let err):
            return "Network error: \(err.localizedDescription)"
        case .decodingError(let err):
            return "Decoding error: \(err.localizedDescription)"
        }
    }
}


@Observable
final class OpenWeatherAPIManager {
    static let shared = OpenWeatherAPIManager()
    private let apiKey: String
    private init() {
        self.apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String ?? ""
    }
    
    // MARK: - Generic fetch function
    private func fetch<T:Decodable>(endpoint:OpenWeatherAPIEndpoint) async throws -> T {
        do {
            return try await NetworkManager.shared.request(endpoint: endpoint)
        } catch let error as URLError {
            throw OpenWeatherAPIError.networkError(error)
        } catch let error as DecodingError {
            throw OpenWeatherAPIError.decodingError(error)
        } catch {
            throw error
        }
    }
    
    // MARK: Fetch forecast by city
    func fetchForecast(for city: String) async throws -> WeatherResponseModel {
        
        // Step 1: Get coordinates
        let locations: [GeocodingResponseModel] = try await NetworkManager.shared.request(endpoint: OpenWeatherAPIEndpoint.geo(city: city))
        
        
        guard let location = locations.first else {
            throw OpenWeatherAPIError.noLocationFound
        }
        
        // Step 2: Fetch forecast using coordinates
        return try await fetch(endpoint: .forecast(lat: location.lat, lon: location.lon))
        
    }
    
}
