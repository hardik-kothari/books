//
//  Extensions.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

extension UIViewController {
    func showProgressView() {
        DispatchQueue.main.async(execute: {
            let hud = MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate?.window)!)!, animated: true)
            hud.contentColor = UIColor.white
            hud.bezelView.alpha = 1.0
            hud.bezelView.color = UIColor.clear
            hud.bezelView.style = .solidColor
            hud.backgroundView.color = UIColor.black
            hud.backgroundView.alpha = 0.6
            hud.backgroundView.style = .solidColor
        })
    }
    
    func hideProgressView() {
        DispatchQueue.main.async(execute: {
            MBProgressHUD.hide(for: ((UIApplication.shared.delegate?.window)!)!, animated: true)
        })
    }
    
    func showInternetToast() {
        "Please check your internet connection.".toast(view: self.view)
    }
}

extension String {
    func toast(view: UIView) {
        let label = UILabel()
        label.text = self
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.darkGray
        label.font = UIFont(name: "SFUIText-Regular", size: 16)
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 50)
        label.numberOfLines = 0
        label.sizeToFit()
        label.center = view.center
        let frm = label.frame
        label.frame = CGRect(x: frm.minX - 10, y: UIScreen.main.bounds.height * 0.8, width: frm.width + 20, height: frm.height + 10)
        label.clipsToBounds = true
        label.layer.cornerRadius = 7
        view.addSubview(label)
        UIView.animate(withDuration: 4.0, delay: 2.0, options: [.curveEaseInOut], animations: {
            label.alpha = 0
        }, completion: { _ in
            label.removeFromSuperview()
        })
    }
}

extension UIImageView {
    func setImage(withUrlString url: String, placeHolderImage: UIImage?) {
        if let url = URL(string: url) {
            let optionInfo: KingfisherOptionsInfo = [.transition(ImageTransition.fade(1))]
            self.kf.setImage(with: url, placeholder: placeHolderImage, options: optionInfo) { _ in }
        }
    }
}

extension UISearchBar {
    func enableSearchCancelButton(searchBar: UISearchBar) {
        for view in searchBar.subviews {
            for subview in view.subviews {
                if let button = subview as? UIButton {
                    button.isEnabled = true
                }
            }
        }
    }
}

extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        guard let font = self.font else {
            return
        }
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.visibleTextLength()
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    func getMaxRequiredBounds() -> CGRect {
        guard let text = self.text else {
            return .zero
        }
        let font: UIFont = self.font
        let labelWidth: CGFloat = self.frame.size.width
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        return boundingRect
    }
    
    func visibleTextLength() -> Int {
        guard let font = self.font, let text = self.text else {
            return 0
        }
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let boundingRect: CGRect = self.getMaxRequiredBounds()
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text.count - index - 1)).location
                }
            } while index != NSNotFound && index < text.count && (text as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
