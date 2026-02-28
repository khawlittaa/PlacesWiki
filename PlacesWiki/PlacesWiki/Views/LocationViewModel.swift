//  LocationViewModel.swift
//  PlacesWiki

import SwiftUI
import Combine

@MainActor
final class LocationViewModel: ObservableObject, Identifiable {
    @Published var location: Location
    
    let unnamedLocationText: String
    let accessibilityTemplate: String
    
    var id: Location { location }
    
    init(location: Location) {
        self.location = location
        
        unnamedLocationText = String(localized: "unnamedLocation")
        accessibilityTemplate = String(localized: "accessibilityOpenWikipedia")
    }
    
    var titleText: String {
        location.name ?? unnamedLocationText
    }
    
    var coordinatesText: String {
        "latittude:\(location.lat), longitude:\(location.long)"
    }
    
    var accessibilityLabel: String {
        let name = location.name ?? unnamedLocationText
        let latString = String(format: "%.4f", location.lat)
        let longString = String(format: "%.4f", location.long)
        return String(
            format: accessibilityTemplate,
            name,
            longString,
            latString
        )
    }
}
