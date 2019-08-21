//
//  NetworkManager.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    // MARK: - Variables
    static var isReachable: Bool {
        guard let isReachable = NetworkReachabilityManager()?.isReachable, isReachable == true else {
            return false
        }
        return isReachable
    }
    
    // MARK: - Initialize Methods
    class var sharedInstance: NetworkManager {
        struct Static {
            static var instance: NetworkManager?
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    // MARK: - Request Method
    func requestFor(path: String, param: [String: Any]?, httpMethod: HTTPMethod, includeHeader: Bool, success:@escaping (_ response: [String: Any]) -> Void, failure:@escaping (_ error: Error?) -> Void) {
        let completeURL = NetworkConfiguration.sharedInstance.serverURL + path
        var headerParam: HTTPHeaders?
        if includeHeader {
            headerParam = ["Content-Type": "application/json",
                           "Accept": "application/json",
                           "source": "iOS"
            ]
        }
        if NetworkManager.isReachable {
            Alamofire.request(completeURL, method: httpMethod, parameters: param, encoding: JSONEncoding.default, headers: headerParam).responseJSON { response in
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? [String: Any] {
                        success(responseDict)
                    } else {
                        failure(response.result.error)
                    }
                case .failure:
                    failure(response.result.error)
                }
            }
        } else {
            failure(nil)
        }
    }
}
