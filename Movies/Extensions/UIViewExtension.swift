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
    
    //MARK: - Layout -
    //MARK: - Anchors -
    func pinEdges(to superView: UIView?,
                  topSpace: CGFloat = .zero,
                  leftSpace: CGFloat = .zero,
                  rightSpace: CGFloat = .zero,
                  bottomSpace: CGFloat = .zero) {
        guard let view = superView else {return}
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftSpace),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightSpace),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSpace)
        ])
        view.setNeedsLayout()
    }
    
    func alignCentered(subview: UIView?,
                       xOffset: CGFloat = .zero,
                       yOffset: CGFloat = .zero) {
        guard let subview = subview else {return}
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: centerXAnchor, constant: xOffset),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yOffset)
        ])
        setNeedsLayout()
        
    }
}
    
