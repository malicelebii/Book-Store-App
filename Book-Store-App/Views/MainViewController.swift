//
//  ViewController.swift
//  Book-Store-App
//
//  Created by Mehmet Ali ÇELEBİ on 8.03.2024.
//

import UIKit

protocol ChangeTableData {
    func didChangeData(indicator: UIActivityIndicatorView)
}

class MainViewController: UIViewController, ChangeTableData {
    var booksViewModel = BookViewModel()
    var searchViewModel = SearchViewModel()
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var books = [Book]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProtocols()
        setUpCollectionViewLayout()
        setBooksWith(goBack: false, indicator: IndicatorManager.shared.createActivityIndicator(view: view))
    }

    func setupProtocols() {
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        searchBar.delegate = self
    }
    
    func setBooksWith(goBack: Bool, indicator: UIActivityIndicatorView) {
        Task {
            let booksWithImages = await self.booksViewModel.getBooksWithImages(goBack: goBack)
            self.books = booksWithImages
            DispatchQueue.main.async(){
                if goBack {
                    self.navigationController?.popViewController(animated: true)
                }
                indicator.stopAnimating()
                self.booksCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func AddBarButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAddVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddVC" {
            let addVC = segue.destination as! AddBookViewController
            addVC.delegate = self
        }
    }
    
    func setUpCollectionViewLayout(){
        let layout =  UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30 ) / 2, height: 250)
        booksCollectionView.collectionViewLayout = layout
    }
    
    func didChangeData(indicator: UIActivityIndicatorView) {
       setBooksWith(goBack: true,indicator: indicator)
    }
}

extension MainViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BookCell
        let book = self.books[indexPath.row]
        bookCell.configure(book: book)
        bookCell.layer.borderWidth = 2
        return bookCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = self.books[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "detailsVC") as! BookDetailVC
        detailsVC.bookDetailViewModel.book = book
        detailsVC.bookDeletedDelegate = self
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

var debouncer: Debouncer?
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer?.timer!.invalidate()
        debouncer = Debouncer(delay: 1) {
            guard searchText != "" else {
                self.setBooksWith(goBack: false,indicator: IndicatorManager.shared.createActivityIndicator(view: self.view))
                return
            }
            guard searchText.count > 2 else { return }
            let indicator = IndicatorManager.shared.createActivityIndicator(view: self.view)
            Task {
                let getBooksWithImages = await self.booksViewModel.getBooksWithImages(goBack: false)
                self.searchViewModel.searchBooks(searchText: searchText, books: getBooksWithImages) { result in
                    switch result {
                    case .success(let searchedBooks):
                        self.books = searchedBooks
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
                DispatchQueue.main.async {
                    indicator.stopAnimating()
                    self.booksCollectionView.reloadData()
                }
            }
            }
            
        debouncer?.call()
    }
}
