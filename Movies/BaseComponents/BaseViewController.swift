//
//  BaseViewController.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - Variables -
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = UIColor(red: 1,
                                                    green: 1,
                                                    blue: 1,
                                                    alpha: 0.5)
        activityIndicator.makeRoundCorner(5)
        activityIndicator.layer.zPosition = 1
        return activityIndicator
    }()
    
    //MARK: -Internal
    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.activityIndicator.isHidden = false
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func showErrorAlert(with message: String?) {
        let alert = UIAlertController(title: message ?? "",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func layoutActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

