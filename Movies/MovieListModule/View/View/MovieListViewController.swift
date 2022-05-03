//
//  MovieListViewController.swift
//  Movies
//
//  Created by Danylo Klymov on 28.04.2022.
//

import UIKit

class MovieListViewController: BaseViewController, UISearchBarDelegate {
    
    //MARK: - UIElements -
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds,
                                style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.backgroundColor = .white
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
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortPressed)), animated: true)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.searchController = searchController
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
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
        alert.addAction(UIAlertAction(title: self.presenter.selectedSortType()
                                      == .defaultSort ? "Default ✓" : "Default",
                                      style: .default,
                                      handler: {_ in
            self.presenter.sortPosts(by: .defaultSort)
        }))
        alert.addAction(UIAlertAction(title: self.presenter.selectedSortType()
                                      == .ratingSort ? "Rating ✓" : "Rating",
                                      style: .default,
                                      handler: { _ in
            self.presenter.sortPosts(by: .ratingSort)
        }))
        alert.addAction(UIAlertAction(title: self.presenter.selectedSortType()
                                      == .dateSort ? "Date ✓" : "Date",
                                      style: .default,
                                      handler: {_ in
            self.presenter.sortPosts(by: .dateSort)
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
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
        presenter.showMovieDetail(with: presenter.item(at: indexPath.row).id)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        self.tableView.tableFooterView = createFooterSpinner()
        if indexPath.row == (presenter.itemsCount() - 3) {
            presenter.pagination()
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
    
    func scrollToTop() {
        let topRow = IndexPath(row: 0,
                               section: 0)
        tableView.scrollToRow(at: topRow,
                              at: .top,
                              animated: false)
    }
}

// MARK: - UISearchResultsUpdating -
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter.searchItems(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.cancelSearch()
    }
}
