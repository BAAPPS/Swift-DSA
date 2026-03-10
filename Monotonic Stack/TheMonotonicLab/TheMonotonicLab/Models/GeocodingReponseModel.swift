//
//  Untitled.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//


struct GeocodingResponseModel: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
