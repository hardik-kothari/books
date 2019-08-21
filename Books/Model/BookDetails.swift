//
//  BookDetails.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookDetails: NSObject {
    var bookId: String!
    var bookImage: String!
    var title: String!
    var authors: [String] = []
    var subtitle: String!
    var bookDescription: String!
    var textSnippet: String!
    var averageRating: Float = 0
    var ratingCount: Int = 0
    var pageCount: Int = 0
    var categories: [String] = []
    var readStatus: String!
}

extension BookDetails {
    convenience init(json: JSON) {
        self.init()
        bookId = json["id"].stringValue
        bookImage = json["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        title = json["volumeInfo"]["title"].stringValue
        if let authorList = json["volumeInfo"]["authors"].arrayObject as? [String] {
            authors = authorList
        }
        subtitle = json["volumeInfo"]["subtitle"].stringValue
        bookDescription = json["volumeInfo"]["description"].stringValue
        textSnippet = json["searchInfo"]["textSnippet"].stringValue
        averageRating = json["volumeInfo"]["averageRating"].floatValue
        ratingCount = json["volumeInfo"]["ratingsCount"].intValue
        pageCount = json["volumeInfo"]["pageCount"].intValue
        if let categoryList = json["volumeInfo"]["categories"].arrayObject as? [String] {
            categories = categoryList
        }
        readStatus = UserDefaults.standard.string(forKey: bookId) ?? "Pending"
    }
}
