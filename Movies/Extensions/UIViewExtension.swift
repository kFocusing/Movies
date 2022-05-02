//
//  UIViewExtension.swift
//  Movies
//
//  Created by Danylo Klymov on 02.05.2022.
//

import UIKit

extension UIView {
    //MARK: - Shadow -
    func addDropShadow(shadowOpacity: Float,
                       shadowRadius: CGFloat,
                       shadowOffset: CGSize,
                       shadowColor: CGColor? = UIColor.black.cgColor,
                       cornerRadius: CGFloat? = nil) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: cornerRadius ?? self.layer.cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        clipsToBounds = true
    }
    
    //MARK: - Rounding -
    func makeRoundCorner(_ rounding: Int) {
        layer.cornerRadius = CGFloat(rounding)
        clipsToBounds = true
    }
}

