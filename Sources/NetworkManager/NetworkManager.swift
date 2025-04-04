// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

/// A protocol that defines the required methods for any network service.
@available(iOS 13.0, *)
public protocol NetworkServiceProtocol {
    /// Fetches and decodes data from the specified URL.
    /// - Parameter url: The URL to fetch data from.
    /// - Returns: A publisher emitting the decoded response or an error.
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error>
}

/// A reusable and testable network layer class responsible for performing HTTP requests.
@available(iOS 13.0, *)
public class NetworkManager: NetworkServiceProtocol {

    /// Singleton instance of NetworkManager.
    @MainActor public static let shared = NetworkManager()

    /// Private initializer to prevent external instantiation.
    private init() {}

    /// Fetches and decodes data from the specified URL.
    /// - Parameter url: The URL to fetch data from.
    /// - Returns: A publisher emitting the decoded response or an error.
    public func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
