//
//  HomeViewController.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/10.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    private let tmdbViewModel: TMDBViewModel = TMDBViewModel()
    private var randomTrendingMovie: TMDBMoviesResponse.TMDBMovie?
    private var bag: DisposeBag = DisposeBag()
    
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
        
        APICaller.shared.fetchNetflixSymbol { [weak self] symbolImage in
            
            image = symbolImage
            image = image.withRenderingMode(.alwaysOriginal)
            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeroHeaderView() -> Void {
        
        /*
        self.tmdbViewModel.trendingMovies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.randomTrendingMovie = movies.randomElement()

                if let poster_path: String = self?.randomTrendingMovie?.poster_path {
                    self?.heroHeaderView?.configure(with: poster_path)
                }
            }.disposed(by: bag)
         */
        
        /// 위의 방식으로 사용해도 큰 문제는 없지만,
        /// 아래의 방식을 이용하면 가독성과 유지보수면에서 향상됨
        /// +) `.map()`과 `.bind()`를 분리하여 `SOLID의 SRP (Single Responsibility Principle, 단일 책임 원칙)을 준수함!`
        /// .map()  ->  데이터 가공 (변환)에 집중
        /// .bind() ->  UI 업데이트에 집중
        self.tmdbViewModel.trendingMovies
            .observe(on: MainScheduler.instance)
            .map { movies -> String? in
                return movies.randomElement()?.poster_path
            }   //  재사용성, 유지보수성 향상을 위해
            .compactMap { $0 }
            .bind { [weak self] poster_path in
                self?.heroHeaderView?.configure(with: poster_path)
            }.disposed(by: bag)
    }
    
    private func bind() -> Void {
        
        /// .subscribe()    ->  Observable의 이벤트를 감지하고 처리하는데 사용
        /// .bind() ->  Observable의 값을 UI에 바인딩하고, 값이 변경될 때 마다 UI를 업데이트
        /// (즉, `.subscribe()`는 UI 업데이트와 관련된 작업에 사용하는 것은 권장되지 않는다.)
        
        self.tmdbViewModel.trendingMovies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.homeFeedTableView.reloadData()
            }.disposed(by: bag)
        
        self.tmdbViewModel.trendingTVs
            .observe(on: MainScheduler.instance)
            .bind { [weak self] tvs in
                self?.homeFeedTableView.reloadData()
            }.disposed(by: bag)

        self.tmdbViewModel.popular
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.homeFeedTableView.reloadData()
            }.disposed(by: bag)

        self.tmdbViewModel.upcomingMovies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.homeFeedTableView.reloadData()
            }.disposed(by: bag)

        self.tmdbViewModel.topRated
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movies in
                self?.homeFeedTableView.reloadData()
            }.disposed(by: bag)
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
        
        do {
            switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                try cell.configure(withTMDBMovies: self.tmdbViewModel.trendingMovies.value(), withTMDBTVs: nil)
                break;
            case Sections.TrendingTV.rawValue:
                try cell.configure(withTMDBMovies: nil, withTMDBTVs: self.tmdbViewModel.trendingTVs.value())
                break;
            case Sections.Popular.rawValue:
                try cell.configure(withTMDBMovies: self.tmdbViewModel.popular.value(), withTMDBTVs: nil)
                break;
            case Sections.UpcomingMovies.rawValue:
                try cell.configure(withTMDBMovies: self.tmdbViewModel.upcomingMovies.value(), withTMDBTVs: nil)
                break;
            case Sections.TopRated.rawValue:
                try cell.configure(withTMDBMovies: self.tmdbViewModel.topRated.value(), withTMDBTVs: nil)
                break;
            default:
                break;
            }
        } catch {
            print("error: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
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
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: Any) {
        
        let previewVC: PreviewViewController = PreviewViewController()
        
        previewVC.configure(with: viewModel as! PreviewViewModel)
        
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct HomeViewControllerRepresentable: UIViewControllerRepresentable {

    // MARK: - UIViewControllerRepresentable - (Required) Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {

        HomeViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct HomeViewControllerRepresentable_PreviewProvider: PreviewProvider {

    static var previews: some View {

        Group {
            HomeViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
