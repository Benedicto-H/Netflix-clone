//
//  UpcomingViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    // MARK: - Stored-Prop
    private var movies: [MoviesResponse.Movie] = [MoviesResponse.Movie]()
    
    // MARK: - Custom View
    private let upcomingTableView: UITableView = {
        
        let tableView: UITableView = UITableView()
        
        tableView.register(UVTableViewCell.self, forCellReuseIdentifier: UVTableViewCell.identifier)
        
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
        
        fetchUpcomingMoviesData()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }
    
    private func fetchUpcomingMoviesData() -> Void {
        
        Task {
            
            do {
                
                movies = try await APICaller.shared.fetchUpcomingMovies().results
                
                print(Thread.isMainThread)
                
                self.upcomingTableView.reloadData()
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: UVTableViewCell = tableView.dequeueReusableCell(withIdentifier: UVTableViewCell.identifier, for: indexPath) as? UVTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieViewModel(
            titleName: movies[indexPath.row].original_title ?? "UNKOWN original_title",
             posterURL: movies[indexPath.row].poster_path ?? "UNKOWN poster_path"))
        
        return cell
    }
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
}
