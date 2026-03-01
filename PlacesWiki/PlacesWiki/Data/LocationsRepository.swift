//  LocationsRepository.swift
//  PlacesWiki

import Foundation

public protocol LocationsRepositoryProtocol: Sendable {
    func fetchLocations() async throws -> [Location]
}

public struct LocationsRepository: LocationsRepositoryProtocol {
    private let networkClient: any NetworkClientProtocol
    private let url: URL

    private static let defaultURL: URL = {
        guard let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json") else {
            preconditionFailure("Hardcoded URL is malformed ")
        }
        return url
    }()

    public init(
        networkClient: any NetworkClientProtocol & Sendable = NetworkClient(),
        url: URL? = nil
    ) {
        self.networkClient = networkClient
        self.url = url ?? Self.defaultURL
    }

    public func fetchLocations() async throws -> [Location] {
        let data = try await networkClient.fetch(url)
        return try JSONDecoder().decode(LocationsResponse.self, from: data).locations
    }
}
