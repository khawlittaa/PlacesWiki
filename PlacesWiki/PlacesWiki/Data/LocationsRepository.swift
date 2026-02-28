//  LocationsRepository.swift
//  PlacesWiki

import Foundation

public protocol LocationsRepositoryProtocol {
    func fetchLocations() async throws -> [Location]
}

public struct LocationsRepository: LocationsRepositoryProtocol, Sendable  {
    private let networkClient: NetworkClientProtocol

    public init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    public func fetchLocations() async throws -> [Location] {
        let data = try await networkClient.fetch(
            "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
        )
        return try JSONDecoder().decode(LocationsResponse.self, from: data).locations
    }
}
