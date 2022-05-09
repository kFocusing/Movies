//
//  CellRegister&DequeueReusableExtension.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

//MARK: - Protocols -
//MARK: - TableViewCellDequeueReusable -
protocol TableViewCellDequeueReusable: UITableViewCell { }

//MARK: - TableViewCellRegistable -
protocol TableViewCellRegistable: UITableViewCell { }

//MARK: - Extensions -
//MARK: - TableViewCellRegistable -
extension TableViewCellRegistable {
    static func register(in tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: String(describing: self))
    }
    
    static func registerXIB(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil),
                           forCellReuseIdentifier: String(describing: self))
    }
}

//MARK: - TableViewCellDequeueReusable -
extension TableViewCellDequeueReusable {
    static func dequeueCell(in tableView: UITableView, indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self),
                                             for: indexPath) as! Self
    }
}
