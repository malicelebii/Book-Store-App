//
//  BookViewModal.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 8.03.2024.
//

import UIKit

class BookViewModel {
    func getBooksWithImages(goBack: Bool) async -> [Book] {
            let books = await getBooks()
            let booksWithImages = await self.fetchImage(books: books)
            return booksWithImages
    }
 
    func fetchImage(books: [Book]) async -> [Book] {
        var copyBook: [Book] = books
        for (index,book) in books.enumerated() {
            let data = try? await getImageData(urlString: book.bookImageUrl ?? "")
            copyBook[index].bookImage = data
        }
        return copyBook
    }
    
    func getImageData(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidUrl }
        do {
            let (imageData,_) =  try await URLSession.shared.data(from: url)
            if let image = UIImage(data: imageData) {
                return image
            } else {
                throw NetworkError.invalidUrl
            }
        } catch  {
            throw NetworkError.noData
        }
    }
    
    func getBooks() async -> [Book] {
        var books = [Book]()
        do {
            books = try await NetworkManager.shared.getBooks()
        } catch {
            print(NetworkError.noData)
        }
        return books
    }
}
