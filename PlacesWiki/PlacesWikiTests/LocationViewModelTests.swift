//  LocationViewModelTests.swift
//  PlacesWikiTests

import Testing
@testable import PlacesWiki

@MainActor
struct LocationViewModelTests {

    @Test("titleText returns name when present")
    func titleText_withName() {
        let sut = LocationViewModel(location: Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339214))
        #expect(sut.titleText == "Amsterdam")
    }

    @Test("titleText falls back to unnamedLocationText")
    func titleText_withoutName() {
        let sut = LocationViewModel(location: Location(name: nil, lat: 40.4380638, long: -3.7495758))
        #expect(sut.titleText == sut.unnamedLocationText)
        #expect(!sut.titleText.isEmpty)
    }

    @Test("coordinatesText contains lat and long")
    func coordinatesText_format() {
        let sut = LocationViewModel(location: Location(name: "Amsterdam", lat: 52.3547498, long: 4.8339214))
        #expect(sut.coordinatesText.contains("52.3547498"))
        #expect(sut.coordinatesText.contains("4.8339214"))
    }

    @Test("id equals the wrapped location")
    func id_equalsLocation() {
        let location = Location(name: "Mumbai", lat: 19.0823998, long: 72.8111468)
        let sut = LocationViewModel(location: location)
        #expect(sut.id == location)
    }

    @Test("accessibilityLabel contains formatted coordinates")
    func accessibilityLabel_containsCoordinates() {
        let sut = LocationViewModel(location: Location(name: "Copenhagen", lat: 55.6713442, long: 12.523785))
        #expect(sut.accessibilityLabel.contains("55.6713"))
        #expect(sut.accessibilityLabel.contains("12.5238"))
    }

    @Test("accessibilityLabel uses unnamedLocationText for nil name")
    func accessibilityLabel_nilName() {
        let sut = LocationViewModel(location: Location(name: nil, lat: 40.4380638, long: -3.7495758))
        #expect(sut.accessibilityLabel.contains(sut.unnamedLocationText))
    }
}
