//
//  HomeViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum Sections: Int {
        case TrendingMovies = 0
        case TrendingTV = 1
        case Popular = 2
        case UpcomingMovies = 3
        case TopRated = 4
    }
    
    // MARK: - Stored-Props
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    private var randomTrendingMovie: TMDBMoviesResponse.TMDBMovie?
    private var heroHeaderView: HeroHeaderUIView?
    
    // MARK: - Custom View
    private let homeFeedTableView: UITableView = {
        
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)    //  Params: cellClass, forCellReuseIdentifier
        
        return tableView
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTableView)
        
        homeFeedTableView.dataSource = self
        homeFeedTableView.delegate = self
        
        heroHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeFeedTableView.tableHeaderView = heroHeaderView
        
        configureNavBar()   //  ->  Pr fetchDataWithCompletionHandler
        configureHeroHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTableView.frame = view.bounds
    }
    
    private func configureNavBar() -> Void {
        
        var image: UIImage = UIImage()
        
        APICaller.shared.fetchNetflixSymbol { symbolImage in
            
            image = symbolImage
            image = image.withRenderingMode(.alwaysOriginal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeroHeaderView() -> Void {
        
        Task {
            do {
                let movies: [TMDBMoviesResponse.TMDBMovie] = try await APICaller.shared.fetchTrendingMovies().results
                
                self.randomTrendingMovie = movies.randomElement()
                self.heroHeaderView?.configure(with: MovieViewModel(titleName: movies.randomElement()?.original_title ?? "", posterURL: movies.randomElement()?.poster_path ?? ""))
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, CollectionViewTableViewCellDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: CollectionViewTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier,
                                                       for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        Task {
            do {
                switch indexPath.section {
                case Sections.TrendingMovies.rawValue:
                    
                    let trendingMovies: TMDBMoviesResponse = try await APICaller.shared.fetchTrendingMovies()
                    
                    cell.configure(withTMDBMovies: trendingMovies.results, withTMDBTVs: nil)
                    break;
                    
                case Sections.TrendingTV.rawValue:
                    
                    let trendingTVs: TMDBTVsResponse = try await APICaller.shared.fetchTrendingTVs()
                    
                    cell.configure(withTMDBMovies: nil, withTMDBTVs: trendingTVs.results)
                    break;
                    
                case Sections.Popular.rawValue:
                    
                    let popular: TMDBMoviesResponse = try await APICaller.shared.fetchPopular()
                    
                    cell.configure(withTMDBMovies: popular.results, withTMDBTVs: nil)
                    break;
                    
                case Sections.UpcomingMovies.rawValue:
                    
                    let upComingMovies: TMDBMoviesResponse = try await APICaller.shared.fetchUpcomingMovies()
                    
                    cell.configure(withTMDBMovies: upComingMovies.results, withTMDBTVs: nil)
                    break;
                    
                case Sections.TopRated.rawValue:
                    
                    let topRated: TMDBMoviesResponse = try await APICaller.shared.fetchTopRated()
                    
                    cell.configure(withTMDBMovies: topRated.results, withTMDBTVs: nil)
                    break;
                    
                default:
                    break;
                }
            } catch {
                fatalError(error.localizedDescription)
            }
            
            return UITableViewCell()
        }
        
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
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    // MARK: - UIScrollViewDelegate - (Optional) Method (-> Protocol. UITableViewDelegate: UIScrollViewDelegate)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {  //  scrollViewDidScroll(_:) - Scroll 할 때마다 계속 호출
        
        let defaultOffset: CGFloat = view.safeAreaInsets.top
        let offset: CGFloat = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    // MARK: - CollectionViewTableViewCellDelegate - (Required) Method  ->  Implementation
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: PreviewViewModel) {
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        previewVC.configure(with: viewModel)
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}
