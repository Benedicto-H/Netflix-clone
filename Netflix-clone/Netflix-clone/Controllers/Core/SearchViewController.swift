//
//  SearchViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    // MARK: - Stored-Props
    private var tmdbMovies: [TMDBMoviesResponse.TMDBMovie] = [TMDBMoviesResponse.TMDBMovie]()
    private let tmdbViewModel: TMDBViewModel = TMDBViewModel()
    private var bag: DisposeBag = DisposeBag()
    
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
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        searchController.searchResultsUpdater = self
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        searchTableView.frame = view.bounds
    }
    
    private func bind() -> Void {
        
        self.tmdbViewModel.discoverMovies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.tmdbMovies = movies
                self?.searchTableView.reloadData()
            }.disposed(by: bag)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tmdbMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        /*
        cell.configure(with: MovieViewModel(
            titleName: tmdbMovies[indexPath.row].original_title ?? "UNKOWN original_title",
             posterURL: tmdbMovies[indexPath.row].poster_path ?? "UNKOWN poster_path"))
         */
        
        cell.configure(with: tmdbMovies[indexPath.row])
        
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
        
        resultsController.delegate = self
        
        Task {
            do {
                resultsController.tmdbMovies = try await APICaller.shared.search(with: query).results
                resultsController.searchResultsCollectionView.reloadData()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie: TMDBMoviesResponse.TMDBMovie = tmdbMovies[indexPath.row]
        
        guard let movieName: String = movie.original_title else { return }
        
        Task {
            do {
                let youTubeDataResponse: YouTubeDataResponse = try await APICaller.shared.fetchVideoFromYouTube(with: movieName)
                let previewVC: PreviewViewController = PreviewViewController()
                
                //  previewVC.configure(with: PreviewViewModel(title: movieName, youTubeView: youTubeDataResponse.items[0], overview: movie.overview ?? ""))
                
                self.navigationController?.pushViewController(previewVC, animated: true)
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - SearchResultsViewControllerDelegate - (required) Method  ->  Implementation
    /*
    func searchResultsViewControllerDidTapItem(_ viewModel: PreviewViewModel) {
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        previewVC.configure(with: viewModel)
        
        navigationController?.pushViewController(previewVC, animated: true)
    }
     */
}
