//
//  EmptyDataSource.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit

class EmptyDataSource: NSObject {
    var placeholderMessage: String! = ""
}

extension EmptyDataSource : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIViewFactory.getPlaceholderView(with: placeholderMessage, parentView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.frame.height
    }
}
