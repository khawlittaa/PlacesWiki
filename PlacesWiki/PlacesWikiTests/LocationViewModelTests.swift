//  LocationViewModelTests.swift
//  PlacesWikiTests

import Testing
import Foundation
@testable import PlacesWiki

@Suite("LocationViewModel")
@MainActor
struct LocationViewModelTests {

    @Test("titleText returns location name when present")
    func titleText_withName() {
        let sut = LocationViewModel(location: Location(name: "Paris", lat: 0, long: 0))
        #expect(sut.titleText == "Paris")
    }

    @Test("titleText falls back to unnamedLocationText when name is nil")
    func titleText_withoutName() {
        let sut = LocationViewModel(location: Location(name: nil, lat: 0, long: 0))
        #expect(sut.titleText == sut.unnamedLocationText)
        #expect(!sut.titleText.isEmpty)
    }

    @Test("coordinatesText contains lat and long values")
    func coordinatesText_format() {
        let sut = LocationViewModel(location: Location(lat: 48.8566, long: 2.3522))
        #expect(sut.coordinatesText.contains("48.8566"))
        #expect(sut.coordinatesText.contains("2.3522"))
    }

    @Test("id equals the wrapped location")
    func id_equalsLocation() {
        let location = Location(name: "Rome", lat: 41.9, long: 12.4)
        let sut = LocationViewModel(location: location)
        #expect(sut.id == location)
    }

    @Test("accessibilityLabel contains formatted coordinates")
    func accessibilityLabel_containsCoordinates() {
        let sut = LocationViewModel(location: Location(name: "Berlin", lat: 52.5200, long: 13.4050))
        #expect(sut.accessibilityLabel.contains("52.5200"))
        #expect(sut.accessibilityLabel.contains("13.4050"))
    }

    @Test("accessibilityLabel uses unnamedLocationText when name is nil")
    func accessibilityLabel_noName() {
        let sut = LocationViewModel(location: Location(name: nil, lat: 0, long: 0))
        #expect(sut.accessibilityLabel.contains(sut.unnamedLocationText))
    }
}

