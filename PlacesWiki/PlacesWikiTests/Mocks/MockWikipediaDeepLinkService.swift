//  MockWikipediaDeepLinkService.swift
//  PlacesWiki

import Foundation
@testable import PlacesWiki

final class MockWikipediaDeepLinkService: WikipediaDeepLinkProtocol {
    var errorToThrow: Error?
    private(set) var openPlacesCalled = false
    private(set) var lastLat: Double?
    private(set) var lastLong: Double?

    func openPlacesSearch(lat: Double, long: Double) async throws {
        openPlacesCalled = true
        lastLat = lat
        lastLong = long
        if let error = errorToThrow { throw error }
    }
}
