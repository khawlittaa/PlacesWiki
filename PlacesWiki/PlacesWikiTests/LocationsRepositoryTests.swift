//  LocationsRepositoryTests.swift
//  PlacesWikiTests

import Testing
import Foundation
@testable import PlacesWiki

@MainActor
struct LocationsRepositoryTests {

    @Test("Decodes valid JSON into locations array")
    func decodesValidJSON() async throws {
        let json = """
        {
            "locations": [
                { "name": "Paris", "lat": 48.8566, "long": 2.3522 },
                { "name": null,    "lat": 41.9028, "long": 12.4964 }
            ]
        }
        """
        let mock = MockNetworkClient()
        mock.dataToReturn = Data(json.utf8)
        let sut = LocationsRepository(networkClient: mock)

        let result = try await sut.fetchLocations()

        #expect(result.count == 2)
        #expect(result[0].name == "Paris")
        #expect(abs(result[0].lat - 48.8566) < 0.0001)
        #expect(result[1].name == nil)
    }

    @Test("Returns empty array for empty locations JSON")
    func emptyLocations() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = Data(#"{ "locations": [] }"#.utf8)
        let sut = LocationsRepository(networkClient: mock)

        let result = try await sut.fetchLocations()

        #expect(result.isEmpty)
    }

    @Test("Throws DecodingError for invalid JSON")
    func invalidJSON() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = Data("not json".utf8)
        let sut = LocationsRepository(networkClient: mock)

        await #expect(throws: (any Error).self) {
            try await sut.fetchLocations()
        }
    }

    @Test("Propagates network errors from client")
    func propagatesNetworkError() async throws {
        let mock = MockNetworkClient()
        mock.errorToThrow = NetworkError.invalidResponse
        let sut = LocationsRepository(networkClient: mock)

        await #expect(throws: NetworkError.invalidResponse) {
            try await sut.fetchLocations()
        }
    }

    @Test("Fetches from the correct URL")
    func correctURL() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = Data(#"{ "locations": [] }"#.utf8)
        let sut = LocationsRepository(networkClient: mock)

        _ = try await sut.fetchLocations()

        #expect(mock.lastFetchedURL == "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")
    }
}
