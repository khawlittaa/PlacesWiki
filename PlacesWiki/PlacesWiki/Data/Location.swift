//  Location.swift
//  PlacesWiki

import Foundation

public struct Location: Codable, Equatable, Hashable {
    public let name: String?
    public let lat: Double
    public let long: Double

    public init(name: String? = nil, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
}
