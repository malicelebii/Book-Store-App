//
//  AddBookViewModel.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 9.03.2024.
//

import UIKit

final class AddBookViewModel {
    func saveBook(book: Book, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://book-store-mern-backend.vercel.app/books") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(book)
        } catch  {
            print(error)
        }
        
        let _ = URLSession.shared.dataTask(with: request){ data,response,error in
            if data != nil {
                completion()
            }
            
            if let error = error {
                print(error)
            }
        }.resume()
        
    }
}
