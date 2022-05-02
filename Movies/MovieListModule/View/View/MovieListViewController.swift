//
//  MovieListViewController.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

class MovieListViewController: BaseViewController {
    
    //MARK: - UIElements -
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero,
                                style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .darkNavy
        table.dataSource = self
        table.delegate = self
        table.isHidden = false
        return table
    }()
    
    //MARK: - Properties -
    var presenter: MovieListPresenterProtocol!
    private var searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    //MARK: - Private -
    private func layoutTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        layoutTableView()
        MoviePreviewXibTableViewCell.registerXIB(in: tableView)
    }

    private func setupNavigationBar() {
        title = "Popular Movies"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = .darkNavy
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortPressed)), animated: true)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.titleView?.backgroundColor = .darkNavy
        navigationItem.searchController = searchController
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Post"
    }
    
    @objc private func sortPressed() {
        showSortAlert()
    }
    
    private func showSortAlert() {
        let alert = UIAlertController(title: "Choose type of sorting",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Default",
                                      style: .default,
                                      handler: {_ in
            self.presenter.sortPosts(by: .defaultSort)
        }))
        alert.addAction(UIAlertAction(title: "Date",
                                      style: .default,
                                      handler: {_ in
            self.presenter.sortPosts(by: .dateSort)
        }))
        alert.addAction(UIAlertAction(title: "Rating",
                                      style: .default,
                                      handler: { _ in
            self.presenter.sortPosts(by: .ratingSort)
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    private func showMovieDetail(with indexPath: IndexPath) {
        //TODO: make prepare movie detail
    }
    
    private func createFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

//MARK: - TableViewExtensions -
//MARK: - UITableViewDataSource -
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MoviePreviewXibTableViewCell.dequeueCell(in: tableView, indexPath: indexPath)
        let item = presenter.item(at: indexPath.item)
        cell.configure(movie: item)
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
//        showMovieDetail(with: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableView.tableFooterView = createFooterSpinner()
        if scrollView.contentOffset.y > (tableView.contentSize
                                            .height-100-scrollView
                                            .frame.size.height) {
            presenter.pagination(stopLoader: disableFooterView)
        }
    }
    
    private func disableFooterView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableFooterView = nil
        }
    }
}


// MARK: - PostListViewProtocol -
extension MovieListViewController: MovieListViewProtocol {
    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func displayError(_ error: String) {
        configureErrorAlert(with: error)
    }
}

// MARK: - UISearchResultsUpdating -
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter.searchItems(searchText)
    }
}


