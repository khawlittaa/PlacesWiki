//  NetworkClient.swift
//  PlacesWiki

import Foundation
import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid server response"
        }
    }
}
public protocol NetworkClientProtocol {
    func fetch(_ urlString: String) async throws -> Data
}

public struct NetworkClient: NetworkClientProtocol {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetch(_ urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        return data
    }
}
