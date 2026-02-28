//  WikipediaDeepLinkService.swift
//  PlacesWiki

import UIKit

public enum DeepLinkError: Error, LocalizedError {
    case unsupportedScheme
    case failedToOpen
    
    public var errorDescription: String? {
        switch self {
        case .unsupportedScheme: return "Wikipedia app not installed"
        case .failedToOpen: return "Failed to open Places tab"
        }
    }
}

public protocol WikipediaDeepLinkProtocol {
    func openPlacesSearch(lat: Double, long: Double) async throws
}

public struct WikipediaDeepLinkService: WikipediaDeepLinkProtocol {
    public func openPlacesSearch(lat: Double, long: Double) async throws {
        let searchQuery = "nearby matching \"lat = \(lat) , long = \(long)\""

        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "wikipedia://places/search?q=\(encodedQuery)") else {
            throw DeepLinkError.unsupportedScheme
        }

        let opened = await UIApplication.shared.open(url)
        guard opened else {
            throw DeepLinkError.failedToOpen
        }
    }
    
    public init() {}
}
