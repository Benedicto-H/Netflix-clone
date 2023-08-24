//
//  UpcomingViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit
import RxSwift
import RxCocoa

class UpcomingViewController: UIViewController {
    
    // MARK: - Stored-Props
    private var tmdbMovies: [TMDBMoviesResponse.TMDBMovie] = [TMDBMoviesResponse.TMDBMovie]()
    private let tmdbViewModel: TMDBViewModel = TMDBViewModel()
    private var bag: DisposeBag = DisposeBag()
    
    // MARK: - Custom View
    private let upcomingTableView: UITableView = {
        
        let tableView: UITableView = UITableView()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        return tableView
    }()

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTableView)
        
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        
        //bind()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }
    
    /*
    private func bind() -> Void {
        
        self.tmdbViewModel.trendingMovies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.tmdbMovies = movies
                self?.upcomingTableView.reloadData()
            }.disposed(by: bag)
    }
     */
}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    // MARK: - UITableViewDelegate - (Optional) Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie: TMDBMoviesResponse.TMDBMovie = tmdbMovies[indexPath.row]
        
        guard let movieName: String = movie.original_title else { return }
        
        /*
        Task {
            do {
                let youTubeDataResponse: YouTubeDataResponse = try await APICaller.shared.fetchVideoFromYouTube(with: movieName)
                let previewVC: PreviewViewController = PreviewViewController()
                
                //previewVC.configure(with: PreviewViewModel(title: movieName, youTubeView: youTubeDataResponse.items[0], overview: movie.overview ?? ""))
                
                self.navigationController?.pushViewController(previewVC, animated: true)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
         */
    }
}
