//
//  UpcomingViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit
import Combine

class UpcomingViewController: UIViewController {
    
    // MARK: - Stored-Props
    private var tmdbMovies: [TMDBMoviesResponse.TMDBMovie] = [TMDBMoviesResponse.TMDBMovie]()
    private let tmdbViewModel: TMDBViewModel = TMDBViewModel()
    private let youTubeViewModel: YouTubeViewModel = YouTubeViewModel()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }
    
    // MARK: - Subscribe
    private func bind() -> Void {
        
        self.tmdbViewModel.upcomingMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.tmdbMovies = movies
                self?.upcomingTableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tmdbMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.configureTableViewCell(with: tmdbMovies[indexPath.row])
        
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
        
        let previewVC: PreviewViewController =  PreviewViewController()
        
        addSubscriptionToYouTubeVMProp(value: movieName)
        
        self.youTubeViewModel.youTubeView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] video in
                previewVC.configurePreview(with: movie, video: video)
            }.store(in: &cancellables)
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // MARK: - Add Subscription To PassthroughSubject (-> YouTubeViewModel Prop)
    private func addSubscriptionToYouTubeVMProp(value: String) -> Void {
        
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
