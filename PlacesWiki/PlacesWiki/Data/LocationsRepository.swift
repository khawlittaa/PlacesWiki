//  LocationsRepository.swift
//  PlacesWiki

import Foundation

public protocol LocationsRepositoryProtocol {
    func fetchLocations() async throws -> [Location]
}

public struct LocationsRepository: LocationsRepositoryProtocol {
    private let networkClient: NetworkClientProtocol

    public init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    public func fetchLocations() async throws -> [Location] {
        try await networkClient.fetch(
            "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json",
            as: LocationsResponse.self
        ).locations
    }
}
