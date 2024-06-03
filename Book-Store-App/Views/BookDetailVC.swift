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
            self.bookDetailViewModel.deleteBook(id: self.bookId!) {
                    self.bookDeletedDelegate?.didChangeData(indicator: indicator)
            }
        }
        ac.addAction(deleteAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac,animated: true)
    }
    
    let tf = UITextField()
    @objc func tapped(sender: UITapGestureRecognizer) {
      
        if let tappedLabel = sender.view as? UILabel {
            tf.text = tappedLabel.text
            tf.isHidden = false
            tf.frame = tappedLabel.frame
            tf.frame.size.width = 200
            
            tf.borderStyle = .roundedRect
            bookName.alpha = 0
            
            stackView.addSubview(tf)
            
            tf.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tf.centerXAnchor.constraint(equalTo: tappedLabel.centerXAnchor),
                tf.centerYAnchor.constraint(equalTo: tappedLabel.centerYAnchor)
            ])
        }
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
            cancelButton.isHidden = false
            editButton.setImage(nil, for: .normal)
            editButton.setTitle("Save", for: .normal)
            break
        default:
            let arr = [bookName, bookAuthor, bookYear]
            let updatedBook = Book(bookId: bookId!, bookName: textFields[0].text!, bookAuthor: textFields[1].text!, bookYear: Int(textFields[2].text!)!)
            let indicator = IndicatorManager.shared.createActivityIndicator(view: self.view)
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
            break
        }
    }
}



