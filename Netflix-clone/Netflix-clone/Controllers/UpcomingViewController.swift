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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = movies[indexPath.row].original_title ?? "UNKOWN"
        
        return cell
    }
    // MARK: - UITableViewDelegate
}
