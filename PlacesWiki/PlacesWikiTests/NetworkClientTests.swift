//  NetworkClientTests.swift
//  PlacesWikiTests

import Testing
import Foundation
@testable import PlacesWiki

@MainActor
@Suite("NetworkClient", .serialized) // 👈 prevents parallel handler overwrites
struct NetworkClientTests {

    @Test("Throws invalidURL for empty URL string")
    func invalidURL() async {
        let sut = NetworkClient()
        await #expect(throws: NetworkError.invalidURL) {
            try await sut.fetch("")
        }
    }

    @Test("Throws invalidResponse for non-2xx status code", arguments: [300, 400, 404, 500])
    func non2xxResponse(statusCode: Int) async throws {
        let session = URLSession.makeMock(data: Data(), statusCode: statusCode)
        let sut = NetworkClient(session: session)

        await #expect(throws: NetworkError.invalidResponse) {
            try await sut.fetch("https://example.com")
        }
    }

    @Test("Returns data for 2xx status code", arguments: [200, 201, 299])
    func validResponse(statusCode: Int) async throws {
        let expected = Data("{}".utf8)
        let session = URLSession.makeMock(data: expected, statusCode: statusCode)
        let sut = NetworkClient(session: session)

        let result = try await sut.fetch("https://example.com")
        #expect(result == expected)
    }
}
