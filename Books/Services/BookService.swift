//
//  BookService.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookService: NSObject {
    
    class func getBooksFromAPI(success: @escaping (_ bookList: [BookDetails]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        NetworkManager.sharedInstance.requestFor(path: "volumes?q=a", param: nil, httpMethod: .get, includeHeader: false, success: { (response) in
            debugPrint(response)
            if let error = response["error"] as? [String:Any], let errorCode = error["code"] as? Int {
                failure(NSError.init(domain: error["message"] as! String, code: errorCode, userInfo: nil))
                return
            }
            var bookList: [BookDetails] = []
            if let booksArray = response["items"] as? [[String: Any]] {
                for bookData in booksArray {
                    bookList.append(BookDetails.init(json: JSON(bookData)))
                }
                success(bookList)
            } else {
                failure(nil)
            }
        }) {(error) in
            failure(error)
        }
    }
}
