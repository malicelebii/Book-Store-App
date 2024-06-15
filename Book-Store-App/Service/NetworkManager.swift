//
//  NetworkManager.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 13.06.2024.
//

import Foundation



class NetworkManager {
        static let shared = NetworkManager()
    
    func getBooks() async throws -> [Book] {
        guard let url = URL(string: "https://book-store-mern-backend.vercel.app/books") else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,  (200...299).contains(httpResponse.statusCode) else { throw NetworkError.networkError  }
        do {
            let books = try JSONDecoder().decode([Book].self, from: data)
            return books
        } catch {
            throw NetworkError.decodingError
        }
    }
}
