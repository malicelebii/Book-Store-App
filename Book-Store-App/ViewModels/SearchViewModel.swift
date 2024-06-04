//
//  SearchViewModel.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 12.03.2024.
//

import Foundation

final class SearchViewModel {
    func searchBooks(searchText: String, books:[Book], completion: @escaping (Result<[Book], Error>) -> ()) {
        let searchedBooks = books.filter { book -> Bool in
             book.bookName.lowercased().contains(searchText.lowercased())
        }
        completion(.success(searchedBooks))
    }
}
