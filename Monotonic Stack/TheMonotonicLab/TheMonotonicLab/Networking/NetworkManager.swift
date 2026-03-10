//
//  OpenWeatherAPIManager.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import Foundation

@Observable
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T:Decodable>(
        endpoint: APIEndpoint
    ) async throws -> T {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        

//        print("🔗 URL being called: \(url.absoluteString)")
//         Print raw JSON for debugging
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("📦 Raw JSON: \(jsonString)")
//        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
