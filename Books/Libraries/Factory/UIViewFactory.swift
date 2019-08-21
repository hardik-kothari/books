//
//  UIViewFactory.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit

class UIViewFactory: NSObject {
    class func getPlaceholderView(with message: String!, parentView: UIView!) -> UIView! {
        let padding = CGFloat(20.0)
        let label = UILabel(frame: CGRect(x: padding, y: 0, width: parentView.bounds.width - (padding * 2), height: 0))
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "SFUIText-Regular", size: 16)!
        label.textAlignment = .center
        label.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        label.text = message
        label.adjustsFontSizeToFitWidth = true
        return label
    }
}
