//
//  TMDBViewModel.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/08/11.
//

import Foundation
import RxSwift
import RxCocoa

final class TMDBViewModel {
    
    // MARK: - Stored-Props
    /// BehaviorSubject가 CurrentValueSubject와 유사
    /// PublishSubject가 PassthroughSubject와 유사
    var trendingMovies: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var trendingTVs: BehaviorSubject<[TMDBTVsResponse.TMDBTV]> = BehaviorSubject(value: [])
    var popular: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var upcomingMovies: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var topRated: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var discoverMovies: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var searchMovies: PublishSubject<[TMDBMoviesResponse.TMDBMovie]> = PublishSubject()
    
    private var bag: DisposeBag = DisposeBag()
    
    init() {
        
        addSubscription()
    }
    
    private func addSubscription() -> Void {
        
        APICaller.shared.fetchTrendingMoviesWithAF_RX()
            .subscribe { [weak self] event in
                switch event {
                case .next(let movieResponse):
                    self?.trendingMovies.onNext(movieResponse.results)
                case .error(let error):
                    print("error: \(error.localizedDescription)")
                case .completed:
                    break;
                }
            }.disposed(by: bag)
        
        APICaller.shared.fetchTrendingTVsWithAF_RX()
            .subscribe { [weak self] event in
                switch event {
                case .next(let tvResponse):
                    self?.trendingTVs.onNext(tvResponse.results)
                case .error(let error):
                    print("error: \(error.localizedDescription)")
                case .completed:
                    break;
                }
            }.disposed(by: bag)
        
        APICaller.shared.fetchPopularWithAF_RX()
            .subscribe { [weak self] event in
                switch event {
                case .next(let movieResponse):
                    self?.popular.onNext(movieResponse.results)
                    break;
                case .error(let error):
                    print("error: \(error.localizedDescription)")
                    break;
                case .completed:
                    break;
                }
            }.disposed(by: bag)
        
        APICaller.shared.fetchUpcomingMoviesWithAF_RX()
            .subscribe { [weak self] event in
                switch event {
                case .next(let movieResponse):
                    self?.upcomingMovies.onNext(movieResponse.results)
                case .error(let error):
                    print("error: \(error.localizedDescription)")
                case .completed:
                    break;
                }
            }.disposed(by: bag)
        
        APICaller.shared.fetchTopRatedWithAF_RX()
            .subscribe { [weak self] event in
                switch event {
                case .next(let movieResponse):
                    self?.topRated.onNext(movieResponse.results)
                case .error(let error):
                    print("error: \(error.localizedDescription)")
                case .completed:
                    break;
                }
            }.disposed(by: bag)
        
        APICaller.shared.fetchDiscoverMoviesWithAF_RX()
            .subscribe { [weak self] event in
                switch event {
                case .next(let movieResponse):
                    self?.discoverMovies.onNext(movieResponse.results)
                case .error(let error):
                    print("error: \(error.localizedDescription)")
                case .completed:
                    break;
                }
            }.disposed(by: bag)
    }
}
