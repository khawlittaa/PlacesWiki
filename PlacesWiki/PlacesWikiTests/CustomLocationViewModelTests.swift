// CustomLocationViewModelTests.swift
//  PlacesWikiTests

import Testing
@testable import PlacesWiki

@MainActor
struct CustomLocationViewModelTests {

    @Test("Fires callback with Amsterdam coordinates")
    func addTapped_validInput() {
        var received: [Location] = []
        let sut = CustomLocationViewModel { received.append($0) }
        sut.latitudeInput = "52.3547498"
        sut.longitudeInput = "4.8339214"

        sut.addTapped()

        #expect(received.count == 1)
        #expect(abs(received[0].lat - 52.3547498) < 0.0001)
        #expect(abs(received[0].long - 4.8339214) < 0.0001)
    }

    @Test("Fires callback with negative coordinates")
    func addTapped_negativeCoordinates() {
        var received: [Location] = []
        let sut = CustomLocationViewModel { received.append($0) }
        sut.latitudeInput = "-3.7495758"
        sut.longitudeInput = "40.4380638"

        sut.addTapped()

        #expect(received.count == 1)
    }

    @Test("Clears input fields after successful add")
    func addTapped_clearsFields() {
        let sut = CustomLocationViewModel { _ in }
        sut.latitudeInput = "52.3547498"
        sut.longitudeInput = "4.8339214"

        sut.addTapped()

        #expect(sut.latitudeInput == "")
        #expect(sut.longitudeInput == "")
    }

    @Test(
        "Does not fire callback for invalid input",
        arguments: [
            ("",             "4.8339214"),
            ("52.3547498",   ""),
            ("abc",          "4.8339214"),
            ("52.3547498",   "xyz"),
            ("inf",          "4.8339214"),
            ("52.3547498",   "nan"),
        ]
    )
    func addTapped_invalidInput(lat: String, lon: String) {
        var received: [Location] = []
        let sut = CustomLocationViewModel { received.append($0) }
        sut.latitudeInput = lat
        sut.longitudeInput = lon

        sut.addTapped()

        #expect(received.isEmpty)
    }

    @Test("Preserves fields when input is invalid")
    func addTapped_preservesFieldsOnInvalidInput() {
        let sut = CustomLocationViewModel { _ in }
        sut.latitudeInput = "bad"
        sut.longitudeInput = "4.8339214"

        sut.addTapped()

        #expect(sut.latitudeInput == "bad")
        #expect(sut.longitudeInput == "4.8339214")
    }
}
