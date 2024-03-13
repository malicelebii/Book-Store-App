//
//  AddBookViewController.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 9.03.2024.
//

import UIKit

class AddBookViewController: UIViewController {
    
    var addBookViewModel = AddBookViewModel()
    
    var delegate: ChangeTableData?
    
    @IBOutlet weak var bookNameTF: UITextField!
    
    @IBOutlet weak var bookAuthorTF: UITextField!
    
    @IBOutlet weak var bookYearTF: UITextField!
    
    @IBOutlet weak var bookImageUrlTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let bookName = bookNameTF.text,
           let bookAuthor = bookAuthorTF.text,
           let bookYear = Int(bookYearTF.text!),
           let bookImageUrl = bookImageUrlTF.text {
            
            let newBook = Book(bookId: "",bookName: bookName, bookAuthor: bookAuthor, bookYear: bookYear, bookImageUrl: bookImageUrl)
            addBookViewModel.saveBook(book: newBook){
                DispatchQueue.main.async{
                    self.delegate?.didChangeData()
                }
            }
        }
    }
}
