//
//  UITableViewExntension.swift
//  Movies
//
//  Created by Danylo Klymov on 04.05.2022.
//

import UIKit

extension UITableView {
    func scrollToTop() {
        DispatchQueue.main.async {
            self.scrollToRow(at: IndexPath(row: 0,
                                                     section: 0),
                                       at: .top,
                                       animated: false)
        }
    }
}
