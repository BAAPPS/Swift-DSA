//
//  APIEndpoint.swift
//  TheMonotonicLab
//
//  Created by D F on 3/10/26.
//

import Foundation

protocol APIEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}
