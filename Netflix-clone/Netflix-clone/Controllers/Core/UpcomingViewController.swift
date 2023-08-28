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
    private let youTubeViewModel: YouTubeViewModel = YouTubeViewModel()
    private var bag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag? = nil
    
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
    
    private func bind() -> Void {
        
        self.tmdbViewModel.trendingMovies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.tmdbMovies = movies
                self?.upcomingTableView.reloadData()
            }.disposed(by: bag)
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
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        disposeBag = DisposeBag()
        
        addObserver(with: movieName)
        
        self.youTubeViewModel.youTubeView
            .observe(on: MainScheduler.instance)
            .bind { [weak self] videoElement in
                previewVC.configurePreviewVC(model: movie, video: videoElement)
            }.disposed(by: disposeBag ?? DisposeBag())
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // MARK: - Add Observer to PublishSubject (-> YouTubeViewModel Prop)
    private func addObserver(with title: String) -> Void {
        
        APICaller.shared.fetchVideoFromYouTubeWithAF_RX(with: title + " trailer")
            .subscribe { [weak self] response in
                self?.youTubeViewModel.youTubeView.onNext(response.items[0])
            } onError: { error in
                self.youTubeViewModel.youTubeView.onError(error)
            }.disposed(by: self.youTubeViewModel.bag)
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct UpcomingViewControllerRepresentable: UIViewControllerRepresentable {

    // MARK: - UIViewControllerRepresentable - (Required) Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {

        UpcomingViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct UpcomingViewControllerRepresentable_PreviewProvider: PreviewProvider {

    static var previews: some View {

        Group {
            UpcomingViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
