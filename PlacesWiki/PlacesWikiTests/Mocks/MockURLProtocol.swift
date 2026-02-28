//  MockURLProtocol.swift
//  PlacesWikiTests

import Foundation
@testable import PlacesWiki

typealias RequestHandler = (URLRequest) throws -> (HTTPURLResponse, Data)

final class MockURLProtocol: URLProtocol {
    // Use a nonisolated lock to avoid data races
    private static var _handler: RequestHandler?
    private static let lock = NSLock()

    static var requestHandler: RequestHandler? {
        get { lock.withLock { _handler } }
        set { lock.withLock { _handler = newValue } }
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

extension URLSession {
    static func makeMock(data: Data, statusCode: Int) -> URLSession {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}
