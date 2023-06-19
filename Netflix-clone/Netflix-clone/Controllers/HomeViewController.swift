//
//  HomeViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Stored-Prop
    let sectionTitles: [String] = ["Trending Movies", "Popular", "Trending TV", "Upcomming Movies", "Top Rated"]
    
    // MARK: - Custom View
    private let homeFeedTable: UITableView = {
        
        let table: UITableView = UITableView(frame: .zero, style: .grouped)
        
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)    //  Params: cellClass, forCellReuseIdentifier
        
        return table
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        let headerView: HeroHeaderUIView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeFeedTable.tableHeaderView = headerView
        
        configureNavBar()
        //  fetchTrendingMoviesWithCompletionHandler()
        fetchTrendingMoviesWithAsyncAwait()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavBar() -> Void {
        
        var image: UIImage = UIImage()
        
        HomeViewController.fetchNetflixSymbol { img in
            
            image = img
            image = image.withRenderingMode(.alwaysOriginal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private static func fetchNetflixSymbol(completionHandler: @escaping (UIImage) -> Void) -> Void {
        
        let originURL: String = "https://images.ctfassets.net/y2ske730sjqp/4aEQ1zAUZF5pLSDtfviWjb/ba04f8d5bd01428f6e3803cc6effaf30/Netflix_N.png?w=300" //  source: https://brand.netflix.com/en/assets/logos
        
        guard let url: URL = URL(string: originURL) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                let logoImage: UIImage? = UIImage(data: safeData)
                
                DispatchQueue.main.async {
                    
                    completionHandler(logoImage ?? UIImage())
                }
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }.resume()
    }
    
    /// fetchTrendingMoviesWithCompletionHandler()   ->  (ver. completionHandler)
    /*
    private func fetchTrendingMoviesWithCompletionHandler() -> Void {
        
        APICaller().fetchTrendingMovies { _ in
            
        }
    }
     */
    
    /// fetchTrendingMoviesWithAsyncAwait()   ->  (ver. Async/Await)
    private func fetchTrendingMoviesWithAsyncAwait() -> Void {
        
        Task {
            
            do {
                
                try await APICaller().fetchTrendingMovies()
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }
    }


}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: CollectionViewTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier,
                                                       for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    // MARK: - UITableViewDataSource - (Optional) Methods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
    }
    
    // MARK: - UITableViewDelegate - (Optional) Method
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else { return }
        
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        //  header.textLabel?.textColor = header.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        header.textLabel?.text = header.textLabel?.text?.lowercased()
         
        /*
        var contentConfiguration = UIListContentConfiguration.subtitleCell()
        contentConfiguration.text = header.textLabel?.text
        contentConfiguration.secondaryText = header.detailTextLabel?.text
        contentConfiguration.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        contentConfiguration.textProperties.color = .black
        contentConfiguration.textProperties.numberOfLines = 0
        
        header.contentConfiguration = contentConfiguration
         */
    }
    
    // MARK: - UIScrollViewDelegate - (Optional) Method (-> Protocol. UITableViewDelegate: UIScrollViewDelegate)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {  //  scrollViewDidScroll(_:) - Scroll 할 때마다 계속 호출
        
        let defaultOffset: CGFloat = view.safeAreaInsets.top
        let offset: CGFloat = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
