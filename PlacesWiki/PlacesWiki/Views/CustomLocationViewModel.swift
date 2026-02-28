//  CustomLocationViewModel.swift
//  PlacesWiki

import SwiftUI
import Combine

@MainActor
final class CustomLocationViewModel: ObservableObject {
    @Published var latitudeInput: String = ""
    @Published var longitudeInput: String = ""
    
    let titleText: String
    let addButtonText: String
    let latitudeLabelText: String
    let longitudeLabelText: String
    let invalidCoordinatesText: String
    let accessibilityLabel = String(localized: "accessibilityAddLocation")
    
    private let onAddLocation: (Location) -> Void
    
    init(onAddLocation: @escaping (Location) -> Void) {
        self.onAddLocation = onAddLocation
        
        titleText = String(localized: "addLocation")
        addButtonText = String(localized: "addLocation")
        latitudeLabelText = String(localized: "latitudeLabel")
        longitudeLabelText = String(localized: "longitudeLabel")
        invalidCoordinatesText = String(localized: "invalidCoordinates")
    }
    
    func addTapped() {
        guard let lat = Double(latitudeInput),
              let lon = Double(longitudeInput),
              lat.isFinite, lon.isFinite else {
            return
        }
        onAddLocation(Location(lat: lat, long: lon))
        latitudeInput = ""
        longitudeInput = ""
    }
}

