//
//  Book.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 8.03.2024.
//

import UIKit

struct Book: Codable {
    var bookId: String
    var bookName: String
    var bookAuthor: String
    var bookYear: Int
    var bookImageUrl: String?
    var bookImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case bookId = "_id"
        case bookName = "title"
        case bookAuthor = "author"
        case bookYear = "publishYear"
        case bookImageUrl = "imageUrl"
        
    }
}

