//
//  BookDetailViewModel.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 9.03.2024.
//


import UIKit

class BookDetailViewModel {
    var book: Book?
    var bookImage: UIImage?
    
    func loadBook(completion: @escaping () -> Void ) {
        if let book = book, let imageUrl = book.bookImageUrl {
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: imageUrl)!)) { data, response, error in
                if let data = data {
                  if let image = UIImage(data: data) {
                      self.bookImage = image
                      DispatchQueue.main.async {
                          completion()
                      }
                  }
                }
            }.resume()
        }
    }
    
    func updateBook(book: Book, completion: @escaping () -> ()) {
        let url = URL(string: "https://book-store-mern-backend.vercel.app/books/\(book.bookId)")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
   
        do {
            let encodedJson = try JSONEncoder().encode(book)
            request.httpBody = encodedJson
            let _ = URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200:
                        completion()
                        break
                    default:
                        print("baska statuscode")
                        break
                    }
                }
            }.resume()
        } catch  {
            print(error)
        }
    }
    
    func deleteBook(id: String, completion: @escaping () -> ()) {
        let url = URL(string: "https://book-store-mern-backend.vercel.app/books/\(id)")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        let _ = URLSession.shared.dataTask(with: request) { _, response, _ in
            if let response = response as? HTTPURLResponse  {
                switch response.statusCode {
                case 200:
                  completion()
                    break;
                default:
                    break
                }
            }
        }.resume()
    }
}
