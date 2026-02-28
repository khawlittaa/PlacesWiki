// CustomLocationViewModelTests.swift
//  PlacesWikiTests

import Testing
import Foundation
@testable import PlacesWiki

@Suite("CustomLocationViewModel")
@MainActor
struct CustomLocationViewModelTests {

    @Test("Fires callback with correct coordinates for valid input")
    func addTapped_validInput_firesCallback() throws {
        var received: [Location] = []
        let sut = CustomLocationViewModel { received.append($0) }
        sut.latitudeInput = "48.8566"
        sut.longitudeInput = "2.3522"

        sut.addTapped()

        #expect(received.count == 1)
        #expect(abs(received[0].lat - 48.8566) < 0.0001)
        #expect(abs(received[0].long - 2.3522) < 0.0001)
    }

    @Test("Clears input fields after successful add")
    func addTapped_clearsFields() {
        let sut = CustomLocationViewModel { _ in }
        sut.latitudeInput = "10.0"
        sut.longitudeInput = "20.0"

        sut.addTapped()

        #expect(sut.latitudeInput == "")
        #expect(sut.longitudeInput == "")
    }

    @Test(
        "Does not fire callback for invalid input",
        arguments: [
            ("",        "2.3522"),
            ("48.8566", ""),
            ("abc",     "2.3522"),
            ("48.8566", "xyz"),
            ("inf",     "2.3522"),
            ("48.8566", "nan"),
        ]
    )
    func addTapped_invalidInput_doesNotFire(lat: String, lon: String) {
        var received: [Location] = []
        let sut = CustomLocationViewModel { received.append($0) }
        sut.latitudeInput = lat
        sut.longitudeInput = lon

        sut.addTapped()

        #expect(received.isEmpty)
    }

    @Test("Does not clear fields when input is invalid")
    func addTapped_invalidInput_preservesFields() {
        let sut = CustomLocationViewModel { _ in }
        sut.latitudeInput = "bad"
        sut.longitudeInput = "2.3522"

        sut.addTapped()

        #expect(sut.latitudeInput == "bad")
        #expect(sut.longitudeInput == "2.3522")
    }

    @Test("Accepts negative coordinates")
    func addTapped_negativeCoordinates() {
        var received: [Location] = []
        let sut = CustomLocationViewModel { received.append($0) }
        sut.latitudeInput = "-33.8688"
        sut.longitudeInput = "-70.6693"

        sut.addTapped()

        #expect(received.count == 1)
    }
}

