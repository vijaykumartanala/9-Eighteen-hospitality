//
//  ExploreCollectionViewCell.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 10/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    
    override var bounds: CGRect {
            didSet {
                self.layoutIfNeeded()
            }
        }
        override func awakeFromNib() {
            super.awakeFromNib()
            self.itemImage.layer.masksToBounds = true
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.setCircularImageView()
        }

        func setCircularImageView() {
            self.itemImage.layer.cornerRadius = CGFloat(roundf(Float(self.itemImage.frame.size.width / 2.0)))
        }
    }

