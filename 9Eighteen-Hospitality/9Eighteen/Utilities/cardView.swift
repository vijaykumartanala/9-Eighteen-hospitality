//
//  cardView.swift
//  Hangers
//
//  Created by vijaykumar on 24/05/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit

@IBDesignable

class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 3
    @IBInspectable var shadowOffsetWidth: Int = 2
    @IBInspectable var shadowOffsetHeight: Int = 2
    @IBInspectable var shadowColor: UIColor? = UIColor.darkGray
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
    }
    
}
