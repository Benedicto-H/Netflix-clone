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
    var trendingMovies: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var trendingTVs: BehaviorSubject<[TMDBTVsResponse.TMDBTV]> = BehaviorSubject(value: [])
    var popular: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var upcomingMovies: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var topRated: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    //  var discoverMovies: BehaviorSubject<[TMDBMoviesResponse.TMDBMovie]> = BehaviorSubject(value: [])
    var searchMovies: PublishSubject<[TMDBMoviesResponse.TMDBMovie]> = PublishSubject()
    
    private var bag: DisposeBag = DisposeBag()
    
    /// BehaviorSubject (-> CurrentValueSubject)
    /// PublishSubject  (-> PassthroughSubject)
    /// DisposeBag  (-> AnyCancellable)
    
    // MARK: - Init
    init() {
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.fetchTrendingMoviesWithAF_RX()
            .subscribe { [weak self] movieResponse in
                self?.trendingMovies.onNext(movieResponse.results)
            } onError: { error in
                self.trendingMovies.onError(error)
            } onCompleted: {
                print("(trendingMovies) - onCompleted")
            }.disposed(by: bag)
        
        APICaller.shared.fetchTrendingTVsWithAF_RX()
            .subscribe { [weak self] tvResponse in
                self?.trendingTVs.onNext(tvResponse.results)
            } onError: { error in
                self.trendingTVs.onError(error)
            } onCompleted: {
                print("(trendingTVs) - onCompleted")
            }.disposed(by: bag)
        
        APICaller.shared.fetchPopularWithAF_RX()
            .subscribe { [weak self] movieResponse in
                self?.popular.onNext(movieResponse.results)
            } onError: { error in
                self.popular.onError(error)
            } onCompleted: {
                print("(popular) - onCompleted")
            }.disposed(by: bag)
        
        APICaller.shared.fetchUpcomingMoviesWithAF_RX()
            .subscribe { [weak self] movieResponse in
                self?.upcomingMovies.onNext(movieResponse.results)
            } onError: { error in
                self.upcomingMovies.onError(error)
            } onCompleted: {
                print("(upcomingMovies) - onCompleted")
            }.disposed(by: bag)
        
        APICaller.shared.fetchTopRatedWithAF_RX()
            .subscribe { [weak self] movieResponse in
                self?.topRated.onNext(movieResponse.results)
            } onError: { error in
                self.topRated.onError(error)
            } onCompleted: {
                print("(topRated) - onCompleted")
            }.disposed(by: bag)
        
//        APICaller.shared.fetchDiscoverMoviesWithAF_RX()
//            .subscribe { [weak self] movieResponse in
//                self?.discoverMovies.onNext(movieResponse.results)
//            } onError: { error in
//                self.discoverMovies.onError(error)
//            } onCompleted: {
//                print("(discoverMovies) - onCompleted")
//            }.disposed(by: bag)
    }
}
