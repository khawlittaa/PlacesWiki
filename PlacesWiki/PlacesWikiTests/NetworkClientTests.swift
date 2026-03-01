//  NetworkClientTests.swift
//  PlacesWikiTests

import Testing
import Foundation
@testable import PlacesWiki

struct NetworkClientTests {
    
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
    
    @Test("Throws invalidURL for non-HTTP scheme")
    func invalidURL() async {
        let sut = await NetworkClient()
        await #expect(throws: NetworkError.invalidURL) {
            try await sut.fetch(URL(string: "ftp://some.server.com")!)
        }
    }
    
    @Test("Propagates network error through repository")
    func networkErrorPropagates() async {
        let mock = MockNetworkClient()
        mock.errorToThrow = NetworkError.invalidResponse
        let sut = await LocationsRepository(networkClient: mock)
        
        await #expect(throws: NetworkError.invalidResponse) {
            try await sut.fetchLocations()
        }
    }
    
    @Test("Returns decoded locations when client returns valid data")
    func validDataDecodedSuccessfully() async throws {
        let mock = MockNetworkClient()
        mock.dataToReturn = locationsData()
        let sut = await LocationsRepository(networkClient: mock)
        
        let result = try await sut.fetchLocations()
        
        #expect(result.count == 4)
    }
}
