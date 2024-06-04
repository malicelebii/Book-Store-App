//
//  BookDetailVC.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 9.03.2024.
//

import UIKit

class BookDetailVC: UIViewController {
    var bookDetailViewModel = BookDetailViewModel()
    var bookDeletedDelegate: ChangeTableData?
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var inEditMode: Bool = false
    var bookId: String?
    var textFields: [UITextField] = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        bookDetailViewModel.loadBook() {
            if let bookImage = self.bookDetailViewModel.bookImage {
                self.bookImage.image = bookImage
            }
        }
        setupBook()
    }
    
    func setupBook() {
        bookName.text = bookDetailViewModel.book?.bookName
        bookAuthor.text = "\(bookDetailViewModel.book!.bookAuthor)"
        bookYear.text = "\(bookDetailViewModel.book!.bookYear)"
        bookId = bookDetailViewModel.book?.bookId
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Delete", message: "Are you sure to delete this book ?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let indicator = IndicatorManager.shared.createActivityIndicator(view: self.view)
            if let id = self.bookId {
                self.bookDetailViewModel.deleteBook(id: id) {
                        self.bookDeletedDelegate?.didChangeData(indicator: indicator)
                }
            }
        }
        ac.addAction(deleteAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac,animated: true)
    }
   
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        inEditMode = false
        self.editButton.setTitle("Edit", for: .normal)
        sender.isHidden = true
        for tf in textFields {
            tf.isHidden = true
            bookName.alpha = 1
            bookAuthor.alpha = 1
            bookYear.alpha = 1
        }
        textFields.removeAll()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        inEditMode = !inEditMode
        switch inEditMode {
        case true:
            for label in [bookName, bookAuthor, bookYear] {
                createTfForEditing(label: label)
            }
            cancelButton.isHidden = false
            editButton.setImage(nil, for: .normal)
            editButton.setTitle("Save", for: .normal)
            break
        default:
            let arr = [bookName, bookAuthor, bookYear]
            var updatedBook: Book?
        
            if let id = bookId, let name = textFields[0].text, let author = textFields[1].text, let year = Int(textFields[2].text ?? "0") {
                updatedBook = Book(bookId: id, bookName: name, bookAuthor: author, bookYear: year)
            }
            let indicator = IndicatorManager.shared.createActivityIndicator(view: self.view)
            if let updatedBook = updatedBook {
                bookDetailViewModel.updateBook(book: updatedBook) {
                    DispatchQueue.main.async {
                        for (i,textField) in self.textFields.enumerated() {
                            arr[i]?.text = textField.text
                            arr[i]?.alpha = 1
                            textField.isHidden = true
                        }
                        self.editButton.setTitle("Edit", for: .normal)
                        self.cancelButton.isHidden = true
                        self.bookDeletedDelegate?.didChangeData(indicator: indicator)
                    }
                }
            }
            break
        }
    }
    
    func createTfForEditing(label: UILabel?) {
        let tf = UITextField()
        tf.text = label!.text
        tf.isHidden = false
        tf.frame = label!.frame
        tf.frame.size.width = 200
        tf.borderStyle = .roundedRect
        label?.alpha = 0
        stackView.addSubview(tf)
        tf.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tf.centerXAnchor.constraint(equalTo: label!.centerXAnchor),
            tf.centerYAnchor.constraint(equalTo: label!.centerYAnchor)
        ])
        textFields.append(tf)
    }
}



