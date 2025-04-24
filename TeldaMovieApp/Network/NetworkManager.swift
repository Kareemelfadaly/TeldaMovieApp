//
//  NetworkManager.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    /// Generic network request for decodable responses
    func request<T: Decodable>(urlString: String,
                                completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL(urlString)))
            return
        }

        // Use URLSession's shared instance — consider injecting a custom session for testability
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error (transport): \(error.localizedDescription)")
                print("🔎 Debug info: \(error)")
                completion(.failure(NetworkError.transport(error)))
                return
            }

            guard let data = data else {
                print("❌ No data received")
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("❌ Decoding failed: \(error)")
                print("🧾 Raw response: \(String(data: data, encoding: .utf8) ?? "nil")")
                completion(.failure(NetworkError.decoding(error)))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL(String)
    case transport(Error)
    case emptyData
    case decoding(Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL(let url): return "Invalid URL: \(url)"
        case .transport(let error): return "Network error: \(error.localizedDescription)"
        case .emptyData: return "No data received"
        case .decoding(let error): return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
