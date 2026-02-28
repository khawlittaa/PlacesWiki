//  LoadingView.swift
//  PlacesWiki


import SwiftUI

struct LoadingView: View {
    let loadingText: String 
    
    var body: some View {
        HStack(spacing: PlacesWikiSpacing.s) {
            ProgressView()
            Text(loadingText)
                .font(PlacesWikiFonts.caption)
                .foregroundStyle(PlacesWikiColors.textSecondary)
        }
        .padding(PlacesWikiSpacing.s)
        .background(PlacesWikiColors.surface, in: RoundedRectangle(cornerRadius: PlacesWikiRadius.s))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "accessibilityLoadingMessage"))
    }
}

#Preview {
    LoadingView(loadingText: "Loading locations...")
}
