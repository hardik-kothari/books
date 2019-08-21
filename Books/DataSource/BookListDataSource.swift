//
//  BookListDataSource.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit

@objc protocol BookListDatasourceDelegate {
    func didSelect(BookDetails bookDetails: BookDetails)
}

class BookListDataSource: NSObject {
    
    // MARK: - Variables
    var expandedCellIndex: Int = -1
    fileprivate var tableView: UITableView!
    lazy var bookList: [BookDetails] = []
    weak var delegate: BookListDatasourceDelegate?
    
    // MARK: - Initialization method
    convenience init(with tableView: UITableView) {
        self.init()
        tableView.register(UINib.init(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        self.tableView = tableView
    }
}

extension BookListDataSource: UITableViewDataSource {
    
    // MARK: - TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as? BookCell {
            cell.showBookDetails(bookList[indexPath.row])
            cell.btnReadStatus.tag = indexPath.row
            cell.btnReadStatus.addTarget(self, action: #selector(bookRead(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func bookRead(sender: UIButton) {
        let bookDetails = bookList[sender.tag]
        if bookDetails.readStatus == "Pending" {
            bookDetails.readStatus = "Read"
            sender.setImage(#imageLiteral(resourceName: "read"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "unread"), for: .normal)
            bookDetails.readStatus = "Pending"
        }
        UserDefaults.standard.set(bookDetails.readStatus, forKey: bookDetails.bookId)
        UserDefaults.standard.synchronize()
    }
}

extension BookListDataSource: UITableViewDelegate {
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let delegate = delegate {
            delegate.didSelect(BookDetails: bookList[indexPath.row])
        }
    }
}
