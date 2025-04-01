// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

@available(iOS 13.0, *)
public class NetworkManager {
    @MainActor public static let shared = NetworkManager()
    
    private init() {}
    
    public func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
