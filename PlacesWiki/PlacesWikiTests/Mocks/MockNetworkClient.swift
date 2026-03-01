//  MockNetworkClient.swift
//  PlacesWikiTests

import Foundation
@testable import PlacesWiki

final class MockNetworkClient: NetworkClientProtocol, @unchecked Sendable {
    var dataToReturn: Data?
    var errorToThrow: Error?
    private(set) var lastFetchedURL: URL?

    func fetch(_ url: URL) async throws -> Data {
        lastFetchedURL = url
        if let error = errorToThrow { throw error }
        return dataToReturn ?? Data()
    }
}

final class BundleToken {}
