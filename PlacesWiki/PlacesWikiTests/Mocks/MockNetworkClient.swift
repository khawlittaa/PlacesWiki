//  MockNetworkClient.swift
//  PlacesWikiTests

import Foundation
@testable import PlacesWiki

final class MockNetworkClient: NetworkClientProtocol, @unchecked Sendable {
    var dataToReturn: Data?
    var errorToThrow: Error?
    private(set) var lastFetchedURL: String?

    func fetch(_ urlString: String) async throws -> Data {
        lastFetchedURL = urlString
        if let error = errorToThrow { throw error }
        return dataToReturn ?? Data()
    }
}
