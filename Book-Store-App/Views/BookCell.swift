//
//  BookCell.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 8.03.2024.
//

import UIKit

class BookCell: UICollectionViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    
    func configure(book: Book) {
        bookName.text = book.bookName
        bookAuthor.text = "\(book.bookAuthor)"
        bookYear.text = "\(book.bookYear)"
        bookImage.image = book.bookImage
    }
}
