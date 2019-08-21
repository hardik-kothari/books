//
//  BookDetailsVC.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit

class BookDetailsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var lblAuthors: UILabel!
    @IBOutlet weak var lblCategories: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblPageCount: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblTextSnippet: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var textSnipperHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    var bookDetails: BookDetails!
    let maxLabelHeight: CGFloat = 80
    var requiredDescHeight: CGFloat = 0
    var requiredTextSnippetHeight: CGFloat = 0
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        showBookDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Update UI Methods
    func showBookDetails() {
        self.navigationItem.title = bookDetails.title
        imgThumbnail.setImage(withUrlString: bookDetails.bookImage, placeHolderImage: #imageLiteral(resourceName: "noimage"))
        lblBookTitle.text = bookDetails.title
        lblAuthors.text = bookDetails.authors.joined(separator: ", ")
        lblCategories.text = "Category: " + bookDetails.categories.joined(separator: ", ")
        ratingView.rating = bookDetails.averageRating
        lblRatingCount.text = "(\(bookDetails.ratingCount))"
        lblPageCount.text = "Pages: \(bookDetails.pageCount)"
        lblSubtitle.text = bookDetails.subtitle
        lblTextSnippet.text = bookDetails.textSnippet
        lblDescription.text = bookDetails.bookDescription
        
        setTextSnippetLabel()
        setDescriptionLabel()
    }
    
    func setTextSnippetLabel() {
        requiredTextSnippetHeight = lblTextSnippet.getMaxRequiredBounds().size.height
        if requiredTextSnippetHeight > maxLabelHeight {
            textSnipperHeight.constant = maxLabelHeight
            view.layoutIfNeeded()
            lblTextSnippet.addTrailing(with: "...", moreText: "more", moreTextFont: UIFont.init(name: "SFUIText-Bold", size: 14.0)!, moreTextColor: .white)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.moreButtonTapped(_:)))
            lblTextSnippet.addGestureRecognizer(tapGesture)
        } else {
            textSnipperHeight.constant = requiredTextSnippetHeight
            view.layoutIfNeeded()
        }
    }
    
    func setDescriptionLabel() {
        requiredDescHeight = lblDescription.getMaxRequiredBounds().size.height
        if requiredDescHeight > maxLabelHeight {
            descriptionHeight.constant = maxLabelHeight
            view.layoutIfNeeded()
            lblDescription.addTrailing(with: "...", moreText: "more", moreTextFont: UIFont.init(name: "SFUIText-Bold", size: 14.0)!, moreTextColor: .white)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.moreButtonTapped(_:)))
            lblDescription.addGestureRecognizer(tapGesture)
        } else {
            descriptionHeight.constant = requiredDescHeight
            view.layoutIfNeeded()
        }
    }
    
    @objc func moreButtonTapped(_ sender: UITapGestureRecognizer) {
        if sender.view == lblDescription {
            lblDescription.text = bookDetails.bookDescription
            descriptionHeight.constant = requiredDescHeight
            view.layoutIfNeeded()
        } else {
            lblTextSnippet.text = bookDetails.textSnippet
            textSnipperHeight.constant = requiredTextSnippetHeight
            view.layoutIfNeeded()
        }
    }
}
