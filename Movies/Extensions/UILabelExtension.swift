//
//  UILabelExtension.swift
//  Movies
//
//  Created by Danylo Klymov on 03.05.2022.
//

import UIKit

extension UILabel {
    //MARK: - Shadow -
    func dropShadow(shadowOffset: CGSize = CGSize(width: 1, height: 1),
                    shadowColor: UIColor = .black) {
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
    }
}
