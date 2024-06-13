//
//  NetworkManager.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 13.06.2024.
//

import Foundation



class NetworkManager {
        static let shared = NetworkManager()
    
    func getBooks() {
        // TODO : write func with async-await
//        guard let url = URL(string: "https://book-store-mern-backend.vercel.app/books") else { completion(.failure(.invalidUrl))
//            return
//        }
//        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    let books = try JSONDecoder().decode([Book].self, from: data)
//                    completion(.success(books))
//                } catch  {
//                    completion(.failure(.decodingError))
//                }
//            }
//            
//            if error != nil {
//                completion(.failure(.noData))
//            }
//        }
//        task.resume()
    }
}
