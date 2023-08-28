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
    private let youTubeViewModel: YouTubeViewModel = YouTubeViewModel()
    private var bag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag? = nil
    
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
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultsController: SearchResultsViewController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultsController.delegate = self
        
        addObserverToTMDBVMProp(with: query)
        
        self.tmdbViewModel.searchMovies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                resultsController.tmdbMovies = movies
                resultsController.searchResultsCollectionView.reloadData()
            }.disposed(by: bag)
    }
    
    // MARK: - Add Observer to PublishSubject (-> TMDBViewModel Prop)
    private func addObserverToTMDBVMProp(with query: String) -> Void {
        
        APICaller.shared.searchWithAF_RX(with: query)
            .subscribe { [weak self] response in
                self?.tmdbViewModel.searchMovies.onNext(response.results)
            } onError: { error in
                self.tmdbViewModel.searchMovies.onError(error)
            }.disposed(by: self.tmdbViewModel.bag)
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie: TMDBMoviesResponse.TMDBMovie = tmdbMovies[indexPath.row]
        let previewVC: PreviewViewController = PreviewViewController()
        
        disposeBag = DisposeBag()
        
        addObserverToYouTubeVMProp(title: movie.original_title ?? "")
        
        self.youTubeViewModel.youTubeView
            .observe(on: MainScheduler.instance)
            .bind { [weak self] videoElement in
                previewVC.configurePreviewVC(model: movie, video: videoElement)
            }
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // MARK: - SearchResultsViewControllerDelegate - (required) Method  ->  Implementation
    func searchResultsViewControllerDidTapItem(_ viewModel: Any) {
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        disposeBag = DisposeBag()
        
        if let movie: TMDBMoviesResponse.TMDBMovie = viewModel as? TMDBMoviesResponse.TMDBMovie {
            addObserverToYouTubeVMProp(title: movie.original_title ?? "")
            
            self.youTubeViewModel.youTubeView
                .observe(on: MainScheduler.instance)
                .bind { [weak self] videoElement in
                    previewVC.configurePreviewVC(model: viewModel, video: videoElement)
                }.disposed(by: disposeBag ?? DisposeBag())
        }
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // MARK: - Add Observer to PublishSubject (-> YouTubeViewModel Prop)
    private func addObserverToYouTubeVMProp(title: String) -> Void {
        
        APICaller.shared.fetchVideoFromYouTubeWithAF_RX(with: title)
            .subscribe { [weak self] response in
                self?.youTubeViewModel.youTubeView.onNext(response.items[0])
            } onError: { error in
                self.youTubeViewModel.youTubeView.onError(error)
            }.disposed(by: self.youTubeViewModel.bag)
    }
}
