//  MockLocationsRepository.swift
//  PlacesWikiTests

import Foundation
@testable import PlacesWiki

final class MockLocationsRepository: LocationsRepositoryProtocol, @unchecked Sendable {
    var locationsToReturn: [Location] = []
    var errorToThrow: Error?
    private(set) var fetchCalled = false

    func fetchLocations() async throws -> [Location] {
        fetchCalled = true
        if let error = errorToThrow { throw error }
        return locationsToReturn
    }
}
