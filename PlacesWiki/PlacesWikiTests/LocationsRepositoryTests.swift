//  LocationsRepositoryTests.swift
//  PlacesWikiTests
import Testing
import Foundation
@testable import PlacesWiki

struct LocationsRepositoryTests {

    private func locationsData() -> Data {
        let bundle = Bundle(for: BundleToken.self)
        guard let url = bundle.url(forResource: "locations", withExtension: "json") else {
            preconditionFailure("locations.json not found in test bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            preconditionFailure("locations.json could not be read")
        }
        return data
    }

    @Test("Decodes all 4 locations from locations.json")
    func decodesAllLocations() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = locationsData()
        let sut = await LocationsRepository(networkClient: mock)

        let result = try await sut.fetchLocations()

        #expect(result.count == 4)
    }

    @Test("Decodes named locations correctly")
    func decodesNamedLocations() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = locationsData()
        let sut = await LocationsRepository(networkClient: mock)

        let result = try await sut.fetchLocations()

        #expect(result[0].name == "Amsterdam")
        #expect(result[0].lat == 52.3547498)
        #expect(result[0].long == 4.8339214)

        #expect(result[1].name == "Mumbai")
        #expect(result[1].lat == 19.0823998)
        #expect(result[1].long == 72.8111468)

        #expect(result[2].name == "Copenhagen")
        #expect(result[2].lat == 55.6713442)
        #expect(result[2].long == 12.523785)
    }

    @Test("Decodes location with null name")
    func decodesNullName() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = locationsData()
        let sut = await LocationsRepository(networkClient: mock)

        let result = try await sut.fetchLocations()

        #expect(result[3].name == nil)
        #expect(abs(result[3].lat - 40.4380638) < 0.0001)
        #expect(abs(result[3].long - (-3.7495758)) < 0.0001)
    }

    @Test("Returns empty array for empty locations JSON")
    func emptyLocationsArray() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = Data(#"{ "locations": [] }"#.utf8)
        let sut = await LocationsRepository(networkClient: mock)

        let result = try await sut.fetchLocations()

        #expect(result.isEmpty)
    }

    @Test("Throws DecodingError for wrong JSON structure")
    func wrongJSONStructure() async {
        let mock = MockNetworkClient()
        mock.dataToReturn = Data(#"{ "wrongKey": [] }"#.utf8)
        let sut = await LocationsRepository(networkClient: mock)

        await #expect(throws: (any Error).self) {
            try await sut.fetchLocations()
        }
    }

    @Test("Throws DecodingError for malformed JSON")
    func malformedJSON() async {
        let mock = MockNetworkClient()
        mock.dataToReturn = Data("not json".utf8)
        let sut = await LocationsRepository(networkClient: mock)

        await #expect(throws: (any Error).self) {
            try await sut.fetchLocations()
        }
    }

    @Test("Propagates network error from client")
    func propagatesNetworkError() async {
        let mock = MockNetworkClient()
        mock.errorToThrow = NetworkError.invalidResponse
        let sut = await LocationsRepository(networkClient: mock)

        await #expect(throws: NetworkError.invalidResponse) {
            try await sut.fetchLocations()
        }
    }
}
