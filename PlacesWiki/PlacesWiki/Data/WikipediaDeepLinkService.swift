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
        let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "wikipedia://places/search?q=\(encodedQuery)"


        let url = URL(string: urlString)
    await UIApplication.shared.open(url!)
//        guard let url = URL(string: urlString),
//              UIApplication.shared.canOpenURL(url) else {
//            throw DeepLinkError.unsupportedScheme
//        }
//
//        let opened = await withCheckedContinuation { continuation in
//            UIApplication.shared.open(url) { success in
//                continuation.resume(returning: success)
//            }
//        }
//
//        guard opened else { throw DeepLinkError.failedToOpen }
    }

    public init() {}
}
