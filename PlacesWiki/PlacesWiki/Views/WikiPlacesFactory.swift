//  WikiPlacesFactory.swift
//  PlacesWiki

import SwiftUI

public enum WikiPlacesFactory {

    @MainActor
    public static func makeMainView() -> some View {
        
        let locationsViewModel = LocationsViewModel(
            locationsRepository: LocationsRepository(),
            wikipediaService: WikipediaDeepLinkService()
        )

        let customLocationViewModel = CustomLocationViewModel { location in
            locationsViewModel.appendCustomLocation(location)
        }

        return MainView(
            locationsViewModel: locationsViewModel,
            customLocationViewModel: customLocationViewModel
        )
    }
}

