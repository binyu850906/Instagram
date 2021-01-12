//
//  InstragramCollectionViewCell.swift
//  Instagram
//
//  Created by binyu on 2021/1/7.
//

import UIKit

class InstragramCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showImagesView: UIImageView!
    @IBOutlet weak var cellWidthConstraints: NSLayoutConstraint!

    static let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)
    override func awakeFromNib() {
            super.awakeFromNib()
            cellWidthConstraints?.constant = Self.width
        }
}
