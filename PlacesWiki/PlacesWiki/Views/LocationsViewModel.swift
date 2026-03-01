//  LocationsViewModel.swift
//  PlacesWiki

import SwiftUI
import Combine

@MainActor
public final class LocationsViewModel: ObservableObject {
    @Published public private(set) var locations: [Location] = []
    @Published public private(set) var isLoading = false
    @Published public private(set) var errorMessage: String?
    
    let titleText: String
    let loadingText: String
    
    private let locationsRepository: LocationsRepositoryProtocol
    private let wikipediaService: WikipediaDeepLinkProtocol

    public init(
        locationsRepository: LocationsRepositoryProtocol,
        wikipediaService: WikipediaDeepLinkProtocol
    ) {
        self.locationsRepository = locationsRepository
        self.wikipediaService = wikipediaService

        titleText = String(localized: "appTitle")
        loadingText = String(localized: "loadingLocations")
    }
    
    public func loadLocations() async {
        isLoading = true
        errorMessage = nil
        do {
            locations = try await self.locationsRepository.fetchLocations()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
        
    }
    
    public func appendCustomLocation(_ location: Location) {
        locations.append(location)
    }
    
    public func openWikipediaPlace(for location: Location) async {
        isLoading = true
        errorMessage = nil
        do {
            try await wikipediaService.openPlacesSearch(lat: location.lat, long: location.long)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
