//
//  OpenWeatherAPI.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import Foundation

enum OpenWeatherAPIEndpoint: String {
    case forecast
    case geo
    var path: String {rawValue}
}
