//
//  SearchViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Stored-Prop
    private var tmdbMovies: [TMDBMoviesResponse.TMDBMovie] = [TMDBMoviesResponse.TMDBMovie]()
    
    // MARK: - Custom Views
    private let searchTableView: UITableView = {
       
        let tableView: UITableView = UITableView()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        return tableView
    }()
    
    private let searchController: UISearchController = {
       
        let controller: UISearchController = UISearchController(searchResultsController: SearchResultsViewController())
        
        controller.searchBar.placeholder = "Search for a Movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchTableView)
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        fetchDiscoverMovies()
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        searchTableView.frame = view.bounds
    }
    
    /*
    @MainActor
    private func fetchDiscoverMovies() -> Void {

        Task {

            do {

                tmdbMovies = try await APICaller.shared.fetchDiscoverMovies().results

                self.searchTableView.reloadData()
            } catch {

                fatalError(error.localizedDescription)
            }
        }
    }
     */
    
    @MainActor
    private func fetchDiscoverMovies() -> Void {
        
        Task {
            
            do {
                
                tmdbMovies = try await APICaller.shared.fetchDiscoverMovies().results
                await MainActor.run { [weak self] in
                    
                    print(Thread.isMainThread)
                    
                    self?.searchTableView.reloadData()
                }
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tmdbMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieViewModel(
            titleName: tmdbMovies[indexPath.row].original_title ?? "UNKOWN original_title",
             posterURL: tmdbMovies[indexPath.row].poster_path ?? "UNKOWN poster_path"))
        
        return cell
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    // MARK: - UISearchResultsUpdating - (Required) Method
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar: UISearchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultsController: SearchResultsViewController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        Task {
            
            do {
                
                resultsController.tmdbMovies = try await APICaller.shared.search(with: query).results
                
                resultsController.searchResultsCollectionView.reloadData()
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }
    }
}
