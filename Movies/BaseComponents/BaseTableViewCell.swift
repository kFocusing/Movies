//
//  BaseTableViewCell.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell,
                            TableViewCellRegistable,
                            TableViewCellDequeueReusable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
    }
}
