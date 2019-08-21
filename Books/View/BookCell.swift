//
//  BookCell.swift
//  Books
//
//  Created by Hardik on 15/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    // MARK: - Cell Outlets
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthors: UILabel!    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var lblPageCount: UILabel!
    @IBOutlet weak var btnReadStatus: UIButton!
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Update UI Methods
    func showBookDetails(_ bookDetails: BookDetails) {
        imgThumbnail.setImage(withUrlString: bookDetails.bookImage, placeHolderImage: #imageLiteral(resourceName: "noimage"))
        lblTitle.text = bookDetails.title
        lblAuthors.text = bookDetails.authors.joined(separator: ", ")
        ratingView.rating = bookDetails.averageRating
        lblRatingCount.text = "(\(bookDetails.ratingCount))"
        lblPageCount.text = "Pages: \(bookDetails.pageCount)"
        if bookDetails.readStatus == "Pending" {
            btnReadStatus.setImage(#imageLiteral(resourceName: "unread"), for: .normal)
        } else {
            btnReadStatus.setImage(#imageLiteral(resourceName: "read"), for: .normal)
        }
    }
}
