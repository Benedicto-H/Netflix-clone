//
//  DownloadsViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit
import RxSwift
import RxCocoa

class DownloadsViewController: UIViewController {
    
    // MARK: - Stored-Props
    private var tmdbMovieItems: [TMDBMovieItem] = [TMDBMovieItem]()
    private let youTubeViewModel: YouTubeViewModel = YouTubeViewModel()
    private var disposeBag: DisposeBag? = nil
    
    // MARK: - Custom View
    private let downloadedTableView: UITableView = {
        
        let tableView: UITableView = UITableView()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        return tableView
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadedTableView)
        
        downloadedTableView.dataSource = self
        downloadedTableView.delegate = self
        
        fetchMovieForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchMovieForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadedTableView.frame = view.bounds
    }
    
    private func fetchMovieForDownload() -> Void {
        
        DataPersistenceManager.shared.fetchMovieFromContext { [weak self] result in
            
            switch result {
            case .success(let movies):
                self?.tmdbMovieItems = movies
                
                DispatchQueue.main.async {
                    self?.downloadedTableView.reloadData()
                }
                break;
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                fatalError(error.localizedDescription)
                break;
            }
        }
    }
}

extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tmdbMovieItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let movieItem: TMDBMovieItem = tmdbMovieItems[indexPath.row]
        
        cell.configureTableViewCell(with: TMDBMoviesResponse.TMDBMovie(adult: movieItem.adult,
                                                                       backdrop_path: movieItem.backdrop_path,
                                                                       genre_ids: movieItem.genre_ids ?? [],
                                                                       id: Int(movieItem.id),
                                                                       media_type: movieItem.media_type,
                                                                       original_language: movieItem.media_type,
                                                                       original_title: movieItem.original_title,
                                                                       overview: movieItem.overview,
                                                                       popularity: movieItem.popularity,
                                                                       poster_path: movieItem.poster_path,
                                                                       release_date: movieItem.release_date,
                                                                       title: movieItem.title,
                                                                       video: movieItem.video,
                                                                       vote_average: movieItem.vote_average,
                                                                       vote_count: Int(movieItem.vote_count)))
        
        return cell
    }
    
    // MARK: - UITableViewDataSource - (Optional) Method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteMovieWith(model: tmdbMovieItems[indexPath.row]) { [weak self] result in
                switch result {
                case .success(()):
                    print("Deleted from the Context")
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    fatalError(error.localizedDescription)
                }
                
                self?.tmdbMovieItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    // MARK: - UITableViewDelegate - (Optional) Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie: TMDBMovieItem = tmdbMovieItems[indexPath.row]
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        disposeBag = DisposeBag()
        
        addObserverToYouTubeVMProp(title: movie.title ?? "")
        
        self.youTubeViewModel.youTubeView
            .observe(on: MainScheduler.instance)
            .bind { [weak self] videoElement in
                previewVC.configurePreviewVC(model: movie, video: videoElement)
            }.disposed(by: disposeBag ?? DisposeBag())
        
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
