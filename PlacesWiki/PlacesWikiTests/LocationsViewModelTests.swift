//  LocationsViewModelTests.swift
//  PlacesWikiTests

import Testing
import Foundation
@testable import PlacesWiki

@Suite("LocationsViewModel")
@MainActor
struct LocationsViewMode {

    @Test("Sets locations on successful fetch")
    func loadLocations_success() async throws {
        let mock = MockLocationsRepository()
        mock.locationsToReturn = [Location(name: "Paris", lat: 48.85, long: 2.35)]
        let sut = LocationsViewModel(locationsRepository: mock, wikipediaService: MockWikipediaDeepLinkService())

        await sut.loadLocations()

        #expect(sut.locations.count == 1)
        #expect(sut.locations[0].name == "Paris")
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }

    @Test("Sets errorMessage on fetch failure")
    func loadLocations_failure() async throws {
        let mock = MockLocationsRepository()
        mock.errorToThrow = NetworkError.invalidResponse
        let sut = LocationsViewModel(locationsRepository: mock, wikipediaService: MockWikipediaDeepLinkService())

        await sut.loadLocations()

        #expect(sut.errorMessage == NetworkError.invalidResponse.localizedDescription)
        #expect(sut.locations.isEmpty)
        #expect(sut.isLoading == false)
    }

    @Test("Clears stale error message on successful retry")
    func loadLocations_clearsError_onRetry() async throws {
        let mock = MockLocationsRepository()
        mock.errorToThrow = NetworkError.invalidResponse
        let sut = LocationsViewModel(locationsRepository: mock, wikipediaService: MockWikipediaDeepLinkService())
        await sut.loadLocations()

        mock.errorToThrow = nil
        mock.locationsToReturn = [Location(lat: 0, long: 0)]
        await sut.loadLocations()

        #expect(sut.errorMessage == nil)
    }

    @Test("isLoading is false after load completes")
    func isLoading_isFalseAfterCompletion() async throws {
        let sut = LocationsViewModel(
            locationsRepository: MockLocationsRepository(),
            wikipediaService: MockWikipediaDeepLinkService()
        )
        await sut.loadLocations()
        #expect(sut.isLoading == false)
    }

    @Test("Appends new location to existing list")
    func appendCustomLocation() async throws {
        let mock = MockLocationsRepository()
        mock.locationsToReturn = [Location(name: "Rome", lat: 41.9, long: 12.4)]
        let sut = LocationsViewModel(locationsRepository: mock, wikipediaService: MockWikipediaDeepLinkService())
        await sut.loadLocations()

        sut.appendCustomLocation(Location(name: "Custom", lat: 10, long: 20))

        #expect(sut.locations.count == 2)
        #expect(sut.locations.last?.name == "Custom")
    }

    @Test("Calls Wikipedia service with correct coordinates")
    func openWikipediaPlace_callsService() async throws {
        let mockWiki = MockWikipediaDeepLinkService()
        let sut = LocationsViewModel(locationsRepository: MockLocationsRepository(), wikipediaService: mockWiki)

        await sut.openWikipediaPlace(for: Location(name: "Berlin", lat: 52.52, long: 13.405))

        #expect(mockWiki.openPlacesCalled == true)
        #expect(mockWiki.lastLat == 52.52)
        #expect(mockWiki.lastLong == 13.405)
        #expect(sut.isLoading == false)
    }

    @Test("Sets errorMessage when Wikipedia service fails")
    func openWikipediaPlace_setsError() async throws {
        let mockWiki = MockWikipediaDeepLinkService()
        mockWiki.errorToThrow = DeepLinkError.failedToOpen
        let sut = LocationsViewModel(locationsRepository: MockLocationsRepository(), wikipediaService: mockWiki)

        await sut.openWikipediaPlace(for: Location(lat: 0, long: 0))

        #expect(sut.errorMessage == DeepLinkError.failedToOpen.localizedDescription)
        #expect(sut.isLoading == false)
    }
}

