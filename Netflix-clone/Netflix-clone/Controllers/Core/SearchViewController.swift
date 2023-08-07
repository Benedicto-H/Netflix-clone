//
//  SearchViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    // MARK: - Stored-Props
    private var tmdbMovies: [TMDBMoviesResponse.TMDBMovie] = [TMDBMoviesResponse.TMDBMovie]()
    private let tmdbViewModel: TMDBViewModel = TMDBViewModel()
    private let youTubeViewModel: YouTubeViewModel = YouTubeViewModel()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
        
        bind()
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        searchTableView.frame = view.bounds
    }
    
    // MARK: - Subscribe
    private func bind() -> Void {
        
        self.tmdbViewModel.discoverMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                self?.tmdbMovies = movie
                self?.searchTableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tmdbMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.configureTableViewCell(with: tmdbMovies[indexPath.row])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    // MARK: - UISearchResultsUpdating - (Required) Method
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar: UISearchBar = searchController.searchBar
        
        guard let query: String = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultsController: SearchResultsViewController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultsController.delegate = self
        
        addSubscriptionToTMDBVMProp(with: query)
        
        self.tmdbViewModel.searchMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                resultsController.tmdbMovies = movies
                resultsController.searchResultsCollectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie: TMDBMoviesResponse.TMDBMovie = tmdbMovies[indexPath.row]
        
        guard let movieName: String = movie.original_title else { return }
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        addSubscriptionToYouTubeVMProp(with: movieName)
        
        self.youTubeViewModel.youTubeView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] video in
                previewVC.configurePreview(with: movie, video: video)
            }.store(in: &cancellables)
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // MARK: - SearchResultsViewControllerDelegate - (required) Method  ->  Implementation
    func searchResultsViewControllerDidTapItem(_ viewModel: Any, title: String?) -> Void {
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        addSubscriptionToYouTubeVMProp(with: title ?? "")
        
        self.youTubeViewModel.youTubeView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] video in
                previewVC.configurePreview(with: viewModel, video: video)
            }.store(in: &cancellables)
        
        previewVC.configurePreview(with: viewModel, video: nil)
        
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // MARK: - Add Subscription To PassthroughSubject (-> TMDBViewModel Prop)
    private func addSubscriptionToTMDBVMProp(with value: String) -> Void {
        
        APICaller.shared.searchWithCombine(with: value)
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print("error: \(error.localizedDescription)"); break;
                }
            } receiveValue: { [weak self] tmdbMovieResponse in
                self?.tmdbViewModel.searchMovies.send(tmdbMovieResponse.results)
            }.store(in: &cancellables)
    }
    
    // MARK: - Add Subscription To PassthroughSubject (-> YouTubeViewModel Prop)
    private func addSubscriptionToYouTubeVMProp(with value: String) -> Void {
        
        APICaller.shared.fetchVideoFromYouTubeWithCombine(with: value)
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print("error: \(error.localizedDescription)"); break;
                }
            } receiveValue: { [weak self] youTubeDataResponse in
                self?.youTubeViewModel.youTubeView.send(youTubeDataResponse.items[0])
            }.store(in: &cancellables)
    }
}
