//
//  DownloadsViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    // MARK: - Stored-Prop
    private var tmdbMovieItems: [TMDBMovieItem] = [TMDBMovieItem]()

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
        
        //cell.configure(with: MovieViewModel(titleName: tmdbMovieItems[indexPath.row].original_title ?? "UNKOWN original_title", posterURL: tmdbMovieItems[indexPath.row].poster_path ?? "UNKOWN poster_path"))
        
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
                    
                default:
                    break;
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
}
