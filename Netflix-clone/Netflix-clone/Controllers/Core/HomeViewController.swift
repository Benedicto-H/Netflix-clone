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
        case TrendingTVs = 1
        case Popular = 2
        case UpcomingMovies = 3
        case TopRated = 4
    }
    
    // MARK: - Stored-Props
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let tmdbViewModel: TMDBViewModel = TMDBViewModel()
    private let youTubeViewModel: YouTubeViewModel = YouTubeViewModel()
    private var randomTrendingMovie: AnyPublisher<TMDBMoviesResponse.TMDBMovie?, Never>.Output = nil
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
        
        bind()
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
        
        self.tmdbViewModel.trendingMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
            self?.randomTrendingMovie = movies.randomElement()
                if let posterPath: String = self?.randomTrendingMovie?.poster_path {
                    self?.heroHeaderView?.configureHeroHeaderImageView(with: posterPath)
                }
        }.store(in: &cancellables)
    }
    
    // MARK: - Subscribe
    private func bind() -> Void {
        
        self.tmdbViewModel.trendingMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.homeFeedTableView.reloadData()    //  CurrentValueSubject타입의 trendingMovies 변수가 APICaller에 의해 값 변경이 생기면 그 데이터를 통해 새로운 tableView UI를 fetch
            }.store(in: &cancellables)
        
        self.tmdbViewModel.trendingTVs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tvs in
                self?.homeFeedTableView.reloadData()
            }.store(in: &cancellables)
        
        self.tmdbViewModel.popular
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.homeFeedTableView.reloadData()
            }.store(in: &cancellables)
        
        self.tmdbViewModel.upcomingMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.homeFeedTableView.reloadData()
            }.store(in: &cancellables)
        
        self.tmdbViewModel.topRated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.homeFeedTableView.reloadData()
            }.store(in: &cancellables)
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
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            cell.configureCollectionViewTableViewCell(withTMDBMovies: tmdbViewModel.trendingMovies.value,
                           withTMDBTVs: nil)
            break;
            
        case Sections.TrendingTVs.rawValue:
            cell.configureCollectionViewTableViewCell(withTMDBMovies: nil,
                           withTMDBTVs: tmdbViewModel.trendingTVs.value)
            break;
            
        case Sections.Popular.rawValue:
            cell.configureCollectionViewTableViewCell(withTMDBMovies: tmdbViewModel.popular.value,
                           withTMDBTVs: nil)
            break;
            
        case Sections.UpcomingMovies.rawValue:
            cell.configureCollectionViewTableViewCell(withTMDBMovies: tmdbViewModel.upcomingMovies.value,
                           withTMDBTVs: nil)
            break;
            
        case Sections.TopRated.rawValue:
            cell.configureCollectionViewTableViewCell(withTMDBMovies: tmdbViewModel.topRated.value,
                           withTMDBTVs: nil)
            break;
        default:
            break;
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
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: Any, title: String?) -> Void {
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        addSubscriptionToYouTubeVMProp(value: title ?? "")
        
        self.youTubeViewModel.youTubeView
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print("error: \(error.localizedDescription)"); break;
                }
            } receiveValue: { [weak self] video in
                previewVC.configurePreview(with: viewModel, video: video)
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
