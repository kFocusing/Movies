//
//  UIViewExtension.swift
//  Movies
//
//  Created by Danylo Klymov on 02.05.2022.
//

import UIKit

extension UIView {
    //MARK: - Shadow -
    func addDropShadow(offset: CGSize,
                   color: UIColor,
                   radius: CGFloat,
                   opacity: Float) {
            layer.masksToBounds = false
            layer.shadowOffset = offset
            layer.shadowColor = color.cgColor
            layer.shadowRadius = radius
            layer.shadowOpacity = opacity

            let backgroundCGColor = backgroundColor?.cgColor
            backgroundColor = nil
            layer.backgroundColor =  backgroundCGColor
        }

    //MARK: - Rounding -
    func makeRoundCorner(_ cornerRadius: Int) {
        layer.cornerRadius = CGFloat(cornerRadius)
    }
}

