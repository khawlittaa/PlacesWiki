//  LocationsView.swift
//  PlacesWiki


import SwiftUI

struct LocationsView: View {
    @StateObject var viewModel: LocationsViewModel
    
    var body: some View {
        LazyVStack(spacing: PlacesWikiSpacing.m) {
            ForEach(viewModel.locations, id: \.self) { location in
                let LocationViewModel = LocationViewModel(location: location)
                LocationView(viewModel: LocationViewModel)
                    .onTapGesture {
                        Task {
                            await viewModel.openWikipediaPlace(for: location)
                        }
                    }
            }
        }
    }
}

#Preview {
    LocationsView(viewModel: LocationsViewModel())
}
