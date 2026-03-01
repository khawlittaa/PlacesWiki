//  LocationsViewModelTests.swift
//  PlacesWikiTests
import Testing
@testable import PlacesWiki
import Foundation

@MainActor
struct LocationsViewModelTests {

    private func makeLocations() -> [Location] {[
        Location(name: "Amsterdam",  lat: 52.3547498, long: 4.8339214),
        Location(name: "Mumbai",     lat: 19.0823998, long: 72.8111468),
        Location(name: "Copenhagen", lat: 55.6713442, long: 12.523785),
        Location(name: nil,          lat: 40.4380638, long: -3.7495758)
    ]}

    private func makeSUT(
        repository: MockLocationsRepository = MockLocationsRepository(),
        wikipedia: MockWikipediaDeepLinkService = MockWikipediaDeepLinkService()
    ) -> LocationsViewModel {
        LocationsViewModel(
            locationsRepository: repository,
            wikipediaService: wikipedia
        )
    }

    @Test("Sets locations on successful fetch")
    func loadLocations_success() async {
        let mock = MockLocationsRepository()
        mock.locationsToReturn = makeLocations()
        let sut = makeSUT(repository: mock)

        await sut.loadLocations()

        #expect(sut.locations.count == 4)
        #expect(sut.locations[0].name == "Amsterdam")
        #expect(sut.locations[3].name == nil)
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }

    @Test("Sets errorMessage on fetch failure")
    func loadLocations_failure() async {
        let mock = MockLocationsRepository()
        mock.errorToThrow = NetworkError.invalidResponse
        let sut = makeSUT(repository: mock)

        await sut.loadLocations()

        #expect(sut.errorMessage == NetworkError.invalidResponse.localizedDescription)
        #expect(sut.locations.isEmpty)
        #expect(sut.isLoading == false)
    }

    @Test("Clears stale error on successful retry")
    func loadLocations_clearsErrorOnRetry() async {
        let mock = MockLocationsRepository()
        mock.errorToThrow = NetworkError.invalidResponse
        let sut = makeSUT(repository: mock)
        await sut.loadLocations()

        mock.errorToThrow = nil
        mock.locationsToReturn = makeLocations()
        await sut.loadLocations()

        #expect(sut.errorMessage == nil)
        #expect(sut.locations.count == 4)
    }

    @Test("isLoading is false after load completes")
    func isLoadingFalseAfterCompletion() async {
        let sut = makeSUT()
        await sut.loadLocations()
        #expect(sut.isLoading == false)
    }

    @Test("Appends custom location to existing list")
    func appendCustomLocation() async {
        let mock = MockLocationsRepository()
        mock.locationsToReturn = makeLocations()
        let sut = makeSUT(repository: mock)
        await sut.loadLocations()

        sut.appendCustomLocation(Location(name: "Custom", lat: 10, long: 20))

        #expect(sut.locations.count == 5)
        #expect(sut.locations.last?.name == "Custom")
    }

    @Test("Calls Wikipedia service with correct coordinates")
    func openWikipediaPlace_callsService() async {
        let mockWiki = MockWikipediaDeepLinkService()
        let sut = makeSUT(wikipedia: mockWiki)
        let amsterdam = Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339214)

        await sut.openWikipediaPlace(for: amsterdam)

        #expect(mockWiki.openPlacesCalled == true)
        #expect(mockWiki.lastLat == 52.3547498)
        #expect(mockWiki.lastLong == 4.8339214)
        #expect(sut.isLoading == false)
    }

    @Test("Sets errorMessage when Wikipedia service fails")
    func openWikipediaPlace_setsError() async {
        let mockWiki = MockWikipediaDeepLinkService()
        mockWiki.errorToThrow = DeepLinkError.failedToOpen
        let sut = makeSUT(wikipedia: mockWiki)

        await sut.openWikipediaPlace(for: Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339214))

        #expect(sut.errorMessage == DeepLinkError.failedToOpen.localizedDescription)
        #expect(sut.isLoading == false)
    }
}
