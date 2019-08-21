//
//  NetworkConfiguration.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit

class NetworkConfiguration: NSObject {
    
    var serverURL: String = "https://www.googleapis.com/books/v1/"
    
    // MARK: - Init
    fileprivate override init() {
        super.init()
    }
    
    class var sharedInstance: NetworkConfiguration {
        struct Static {
            static var instance: NetworkConfiguration?
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = NetworkConfiguration()
        }
        return Static.instance!
    }
}
