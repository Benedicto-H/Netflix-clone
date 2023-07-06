//
//  HomeViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit
import Combine

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
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Custom View
    private let homeFeedTableView: UITableView = {
        
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(HVCollectionViewTableViewCell.self, forCellReuseIdentifier: HVCollectionViewTableViewCell.identifier)    //  Params: cellClass, forCellReuseIdentifier
        
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
        
        let heroHeaderView: HVHeroHeaderUIView = HVHeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeFeedTableView.tableHeaderView = heroHeaderView
        
        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTableView.frame = view.bounds
    }
    
    private func configureNavBar() -> Void {
        
        /// fetchNetflixSymbol()    ->  (ver. completionHandler)
        /*
        var image: UIImage
        
        APICaller.shared.fetchNetflixSymbol { symbolImage in
            
            image = symbolImage
            image = image.withRenderingMode(.alwaysOriginal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        }
         */
        
        /// fetchNetflixSymbolWithCombine() ->  (ver. combine)
        var image: UIImage?
        
        APICaller.shared.fetchNetflixSymbolWithCombine()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                //  Error Handling...
                if case let .failure(error) = completion {
                    
                    print("Fetch Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] symbolImage in
                
                image = symbolImage
                image = image?.withRenderingMode(.alwaysOriginal)
                self?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
            }).store(in: &cancellables)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource - (Required) Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: HVCollectionViewTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: HVCollectionViewTableViewCell.identifier,
                                                       for: indexPath) as? HVCollectionViewTableViewCell else { return UITableViewCell() }
        
        Task {
            
            do {
                
                switch indexPath.section {
                case Sections.TrendingMovies.rawValue:
                    
                    let trendingMovies: MoviesResponse = try await APICaller.shared.fetchTrendingMovies()
                    
                    cell.configure(withMovies: trendingMovies.results, withTVs: nil)
                    break;
                    
                case Sections.TrendingTV.rawValue:
                    
                    let trendingTVs: TVsResponse = try await APICaller.shared.fetchTrendingTVs()
                    
                    cell.configure(withMovies: nil, withTVs: trendingTVs.results)
                    break;
                    
                case Sections.Popular.rawValue:
                    
                    let popular: MoviesResponse = try await APICaller.shared.fetchPopular()
                    
                    cell.configure(withMovies: popular.results, withTVs: nil)
                    break;
                    
                case Sections.UpcomingMovies.rawValue:
                    
                    let upComingMovies: MoviesResponse = try await APICaller.shared.fetchUpcomingMovies()
                    
                    cell.configure(withMovies: upComingMovies.results, withTVs: nil)
                    break;
                    
                case Sections.TopRated.rawValue:
                    
                    let topRated: MoviesResponse = try await APICaller.shared.fetchTopRated()
                    
                    cell.configure(withMovies: topRated.results, withTVs: nil)
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
}
