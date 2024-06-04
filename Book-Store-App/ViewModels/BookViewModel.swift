//
//  BookViewModal.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 8.03.2024.
//

import UIKit

class BookViewModel {
    func getBooksWithImages(goBack: Bool,completion: @escaping ([Book]) -> ()) {
        getBooks { result in
            switch result {
            case .success(let books):
                Task{
                    let books = await self.fetchImage(books: books)
                    completion(books)
                }
            case .failure(let networkError):
                print(networkError)
            }
        }
    }
 
    func fetchImage(books: [Book]) async -> [Book] {
        var copyBook: [Book] = books
        for (index,book) in books.enumerated() {
            let data = await getImageData(urlString: book.bookImageUrl ?? "")
            copyBook[index].bookImage = data
        }
        return copyBook
    }
    
    func getImageData(urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        guard let (imageData,_) =  try? await URLSession.shared.data(from: url) else { return  nil }
        return UIImage(data: imageData)
    }
    
    func getBooks(completion: @escaping (Result<[Book],NetworkError>) -> Void) {
        guard let url = URL(string: "https://book-store-mern-backend.vercel.app/books") else { completion(.failure(.invalidUrl))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let books = try JSONDecoder().decode([Book].self, from: data)
                    completion(.success(books))
                } catch  {
                    completion(.failure(.decodingError))
                }
            }
            
            if error != nil {
                completion(.failure(.noData))
            }
        }
        task.resume()
    }
}
