//
//  BookViewModal.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 8.03.2024.
//

import UIKit

class BookViewModel {
    func getBooksWithImages(goBack: Bool,completion: @escaping (Result<[Book], Error>) -> ()) {
        getBooks { result in
            switch result {
            case .success(let books):
                Task{
                    let books = await self.fetchImage(books: books)
                    switch books {
                    case .success(let books):
                        completion(.success(books))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let networkError):
                completion(.failure(NetworkError.noData))
            }
        }
    }
 
    func fetchImage(books: [Book]) async -> Result<[Book], Error> {
        var copyBook: [Book] = books
        for (index,book) in books.enumerated() {
            let data = await getImageData(urlString: book.bookImageUrl ?? "")
            switch data {
            case .success(let image):
                copyBook[index].bookImage = image
            case .failure(let error):
                return .failure(error)
            }
        }
        return .success(copyBook)
    }
    
    func getImageData(urlString: String) async -> Result<UIImage?, NetworkError> {
        guard let url = URL(string: urlString) else { return .failure(.invalidUrl) }
        do {
            let (imageData,_) =  try await URLSession.shared.data(from: url)
            if let image = UIImage(data: imageData) {
                return .success(image)
            } else {
                return .failure(.invalidUrl)
            }
        } catch  {
            return .failure(.noData)
        }
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
