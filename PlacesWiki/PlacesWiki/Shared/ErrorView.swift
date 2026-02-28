//  ErrorView.swift
//  PlacesWiki

import SwiftUI

struct ErrorView: View {
    let message: String 
    
    var body: some View {
        HStack(alignment: .top, spacing: PlacesWikiSpacing.s) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(PlacesWikiColors.error)
            Text(message)
                .font(PlacesWikiFonts.caption)
                .foregroundStyle(PlacesWikiColors.error)
        }
        .padding(PlacesWikiSpacing.s)
        .background(PlacesWikiColors.surface, in: RoundedRectangle(cornerRadius: PlacesWikiRadius.s))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
    }
}

#Preview {
    ErrorView(message: "Example error message")
}

