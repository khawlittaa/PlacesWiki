//  LocationView.swift
//  PlacesWiki

import SwiftUI

struct LocationView: View {
    @ObservedObject var viewModel: LocationViewModel
    
    var body: some View {
        HStack(spacing: PlacesWikiSpacing.s) {
            VStack(alignment: .leading, spacing: PlacesWikiSpacing.xs) {
                Text(viewModel.titleText)
                    .font(PlacesWikiFonts.headline)
                    .foregroundStyle(PlacesWikiColors.textPrimary)
                
                Text(viewModel.coordinatesText)
                    .font(PlacesWikiFonts.caption)
                    .foregroundStyle(PlacesWikiColors.textSecondary)
            }
            Spacer()
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.title2)
                .foregroundStyle(PlacesWikiColors.primary)
        }
        .padding(PlacesWikiSpacing.s)
        .background(PlacesWikiColors.surface)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewModel.accessibilityLabel)
    }
}

#Preview {
    LocationView(
        viewModel: LocationViewModel(
            location: Location(name: "Amsterdam Centraal", lat: 52.3547, long: 4.8339)
        )
    )
}

