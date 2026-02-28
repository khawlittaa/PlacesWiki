//  MainView.swift
//  PlacesWiki

import SwiftUI

struct MainView: View {
    @StateObject var locationsViewModel: LocationsViewModel
    @StateObject var customLocationViewModel: CustomLocationViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: PlacesWikiSpacing.l) {

                    if locationsViewModel.isLoading {
                        LoadingView(loadingText: locationsViewModel.loadingText)
                    }

                    if let error = locationsViewModel.errorMessage {
                        ErrorView(message: error)
                    }

                    CustomLocationView(viewModel: customLocationViewModel)

                    LocationsView(viewModel: locationsViewModel)
                }
                .padding(PlacesWikiSpacing.m)
            }
            .navigationTitle(locationsViewModel.titleText)
            .task { await locationsViewModel.loadLocations() }
            .refreshable { await locationsViewModel.loadLocations() }
        }
    }
}

#Preview {
    let locationsVM = LocationsViewModel()
    let customVM = CustomLocationViewModel { _ in }
    MainView(
        locationsViewModel: locationsVM,
        customLocationViewModel: customVM
    )
}
