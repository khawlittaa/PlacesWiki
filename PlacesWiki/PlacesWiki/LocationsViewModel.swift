//  LocationsViewModel.swift
//  PlacesWiki

import SwiftUI
import Combine

@MainActor
public final class LocationsViewModel: ObservableObject {
    @Published public private(set) var locations: [Location] = []
    @Published public private(set) var isLoading = false
    @Published public var errorMessage: String?

    @Published public var customLatInput = ""
    @Published public var customLongInput = ""

    private let locationsRepository: LocationsRepositoryProtocol
    private let wikipediaDeepLinkService: WikipediaDeepLinkProtocol

    public init(
        locationsRepository: LocationsRepositoryProtocol = LocationsRepository(),
        wikipediaDeepLinkService: WikipediaDeepLinkProtocol = WikipediaDeepLinkService()
    ) {
        self.locationsRepository = locationsRepository
        self.wikipediaDeepLinkService = wikipediaDeepLinkService
    }

    // MARK: Intents
    public func loadLocations() async {
        await execute {
            self.locations = try await self.locationsRepository.fetchLocations()
        }
    }

    public func addCustomLocation() {
        guard let lat = Double(customLatInput),
              let long = Double(customLongInput),
              lat.isFinite, long.isFinite else {
            errorMessage = "Enter valid coordinates (e.g., 52.3547, 4.8339)"
            return
        }

        let newLocation = Location(lat: lat, long: long)
        locations.append(newLocation)
        customLatInput = ""
        customLongInput = ""
        errorMessage = nil
    }

    public func openWikipediaPlace(for location: Location) async {
        await execute {
            try await self.wikipediaDeepLinkService.openPlacesSearch(
                lat: location.lat,
                long: location.long
            )
        }
    }

    // MARK: Private Helpers
    private func execute<T>(_ operation: () async throws -> T) async {
        isLoading = true
        errorMessage = nil

        do {
            _ = try await operation()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

