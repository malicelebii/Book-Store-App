//
//  NetworkError.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 4.06.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case decodingError
    case noData
}
