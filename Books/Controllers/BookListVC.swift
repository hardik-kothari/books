//
//  BookListVC.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit

class BookListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var tblBooks: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var constraintSearchTop: NSLayoutConstraint!
    
    // MARK: - Variables
    var refreshControl: UIRefreshControl?
    var bookList: [BookDetails] = []
    var filteredBookList: [BookDetails] = []
    var datasource: BookListDataSource!
    lazy var emptyDatasource: EmptyDataSource = EmptyDataSource()
    var selectedSort = "Title"
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //SearchBar UI
        searchBar.barTintColor =  UIColor.init(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        searchBar.setShowsCancelButton(true, animated: true)
        if let uiButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            uiButton.tintColor = UIColor.white
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.enableSearchCancelButton(searchBar: searchBar)
        datasource = BookListDataSource(with: tblBooks)
        datasource.delegate = self
        addPullToRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UIButton Actions
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.becomeFirstResponder()
        startSearchAnimation()
    }
    
    @IBAction func sortTapped(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "", message: "Sort by:", preferredStyle: .actionSheet)
        let titleAction = UIAlertAction(title: "Title", style: .default) { action -> Void in
            self.sortBooksBy(param: "Title")
        }
        actionSheetController.addAction(titleAction)
        let authorAction = UIAlertAction(title: "Author", style: .default) { action -> Void in
            self.sortBooksBy(param: "Author")
        }
        actionSheetController.addAction(authorAction)
        let ratingsAction = UIAlertAction(title: "Ratings", style: .default) { action -> Void in
            self.sortBooksBy(param: "Ratings")
        }
        actionSheetController.addAction(ratingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func filterTapped(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "", message: "Filter by:", preferredStyle: .actionSheet)
        let allAction = UIAlertAction(title: "All", style: .default) { action -> Void in
            self.filterBooksBy(param: "All")
        }
        actionSheetController.addAction(allAction)
        let unreadAction = UIAlertAction(title: "Unread", style: .default) { action -> Void in
            self.filterBooksBy(param: "Unread")
        }
        actionSheetController.addAction(unreadAction)
        let topRatedAction = UIAlertAction(title: "Top Rated", style: .default) { action -> Void in
            self.filterBooksBy(param: "Top Rated")
        }
        actionSheetController.addAction(topRatedAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Api Methods
    func getBooksFromCloud(_ showIndecator: Bool = true) {
        if showIndecator {
            showProgressView()
        }
        weak var weakSelf = self
        BookService.getBooksFromAPI(success: {(booksArray) in
            weakSelf?.hideProgressView()
            weakSelf?.bookList = booksArray
            weakSelf?.filteredBookList = booksArray
            weakSelf?.sortBooksBy(param: (weakSelf?.selectedSort)!)
        }) { (error) in
            weakSelf?.hideProgressView()
            weakSelf?.refreshControl?.endRefreshing()
            if let error = error {
                error.localizedDescription.toast(view: self.view)
            } else {
                weakSelf?.showInternetToast()
            }
        }
    }
    
    // MARK: - Pull To Refresh
    func addPullToRefresh() {
        if self.refreshControl != nil {
            self.refreshControl?.removeFromSuperview()
            refreshControl = nil
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.isHidden = false
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl!.attributedTitle = NSAttributedString(string: "")
        self.refreshControl!.addTarget(self, action: #selector(BookListVC.refreshBooksData), for: UIControl.Event.valueChanged)
        tblBooks.insertSubview(refreshControl!, at: 0)
        getBooksFromCloud()
    }
    
    @objc func refreshBooksData() {
        bookList.removeAll()
        filteredBookList.removeAll()
        tblBooks.setContentOffset(CGPoint(x:0, y:self.tblBooks.contentOffset.y - self.refreshControl!.frame.size.height), animated: true)
        refreshControl?.beginRefreshing()
        getBooksFromCloud(false)
    }
    
    // MARK: - Update UI Methods
    func filterBooksBy(param: String) {
        filteredBookList.removeAll()
        if param == "All" {
            for book in bookList {
                filteredBookList.append(book)
            }
        } else if param == "Unread" {
            for book in bookList {
                if book.readStatus == "Pending" {
                    filteredBookList.append(book)
                }
            }
        } else if param == "Top Rated" {
            for book in bookList {
                if book.averageRating >= 4.0 {
                    filteredBookList.append(book)
                }
            }
        }
        sortBooksBy(param: selectedSort)
    }
    
    func sortBooksBy(param: String) {
        selectedSort = param
        if param == "Title" {
            filteredBookList = filteredBookList.sorted(by: { $0.title < $1.title })
        } else if param == "Author" {
            filteredBookList = filteredBookList.sorted(by: { $0.authors.joined(separator: ", ") < $1.authors.joined(separator: ", ") })
        } else if param == "Ratings" {
            filteredBookList = filteredBookList.sorted(by: { $0.averageRating > $1.averageRating })
        }
        reloadTable()
    }
    
    func reloadTable() {
        refreshControl?.endRefreshing()
        if filteredBookList.isEmpty {
            var placeHolderMessage: String = ""
            placeHolderMessage = "No books available."
            emptyDatasource.placeholderMessage = placeHolderMessage
            tblBooks.delegate = emptyDatasource
            datasource.bookList = []
        } else {
            datasource.bookList = filteredBookList
            tblBooks.dataSource = datasource
        }
        tblBooks.reloadData()
    }
    
    func startSearchAnimation() {
        self.constraintSearchTop.constant =  0
        self.view.setNeedsLayout()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            weakSelf?.view.layoutIfNeeded()
        }, completion: { (_: Bool) in
            weakSelf?.searchBar.becomeFirstResponder()
        })
    }
    
    func restoreDefaultAnimation() {
        self.constraintSearchTop.constant =  -50
        self.view.setNeedsLayout()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            weakSelf?.view.layoutIfNeeded()
        }, completion: { (_: Bool) in
            weakSelf?.searchBar.resignFirstResponder()
        })
    }
}

// MARK: UISearchBarDelegate
extension BookListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        if let uiButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            uiButton.tintColor = UIColor.white
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            searchBooksFor(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBooksFor(searchText: searchBar.text!)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBooksFor(searchText: String) {
        let filteredBooks = bookList.filter { (bookDetail) -> Bool in
            let isBookName = bookDetail.title.lowercased().starts(with: searchText.lowercased())
            var isAuthorName = false
            for author in bookDetail.authors {
                isAuthorName = author.lowercased().starts(with: searchText.lowercased())
                if isAuthorName == true {
                    break
                }
            }
            if isBookName || isAuthorName {
                return true
            } else {
                return false
            }
        }
        filteredBookList.removeAll()
        for book in filteredBooks {
            filteredBookList.append(book)
        }
        sortBooksBy(param: selectedSort)
    }
    
    func resetSearch() {
        filteredBookList.removeAll()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        for book in bookList {
            filteredBookList.append(book)
        }
        sortBooksBy(param: selectedSort)
        restoreDefaultAnimation()
    }
}

extension BookListVC: BookListDatasourceDelegate {
    
    func didSelect(BookDetails bookDetails: BookDetails) {
        if let bookDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailsVC") as? BookDetailsVC {
            bookDetailsVC.bookDetails = bookDetails
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                UIView.setAnimationCurve(.easeInOut)
                self.navigationController!.pushViewController(bookDetailsVC, animated: false)
                UIView.setAnimationTransition(.flipFromRight, for: self.navigationController!.view!, cache: false)
            })
        }
    }
}
