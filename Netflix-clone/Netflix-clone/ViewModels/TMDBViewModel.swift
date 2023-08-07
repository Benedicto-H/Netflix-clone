//
//  TMDBViewModel.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/08/07.
//

import Foundation
import Combine

final class TMDBViewModel {
    
    // MARK: - Stored-Props
    var trendingMovies: CurrentValueSubject<[TMDBMoviesResponse.TMDBMovie], Never> = .init([])
    var trendingTVs: CurrentValueSubject<[TMDBTVsResponse.TMDBTV], Never> = .init([])
    var popular: CurrentValueSubject<[TMDBMoviesResponse.TMDBMovie], Never> = .init([])
    var upcomingMovies: CurrentValueSubject<[TMDBMoviesResponse.TMDBMovie], Never> = .init([])
    var topRated: CurrentValueSubject<[TMDBMoviesResponse.TMDBMovie], Never> = .init([])
    var discoverMovies: CurrentValueSubject<[TMDBMoviesResponse.TMDBMovie], Never> = .init([])
    var searchMovies: PassthroughSubject<[TMDBMoviesResponse.TMDBMovie], Never> = .init()
    var downloadsmovies: PassthroughSubject<[TMDBMoviesResponse.TMDBMovie], Never> = .init()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        addSubscription()
    }
    
    private func addSubscription() -> Void {
        
        APICaller.shared.fetchTrendingMoviesWithCombine()
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print(error.localizedDescription); break;
                }
            } receiveValue: { [weak self] movies in
                self?.trendingMovies.send(movies.results)
            }.store(in: &cancellables)
        
        APICaller.shared.fetchTrendingTVsWithCombine()
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print(error.localizedDescription); break;
                }
            } receiveValue: { [weak self] tvs in
                self?.trendingTVs.send(tvs.results)
            }.store(in: &cancellables)
        
        APICaller.shared.fetchPopularWithCombine()
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print(error.localizedDescription); break;
                }
            } receiveValue: { [weak self] movies in
                self?.popular.send(movies.results)
            }.store(in: &cancellables)
        
        APICaller.shared.fetchUpcomingMoviesWithCombine()
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print(error.localizedDescription); break;
                }
            } receiveValue: { [weak self] movies in
                self?.upcomingMovies.send(movies.results)
            }.store(in: &cancellables)
        
        APICaller.shared.fetchTopRatedWithCombine()
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print(error.localizedDescription); break;
                }
            } receiveValue: { [weak self] movies in
                self?.topRated.send(movies.results)
            }.store(in: &cancellables)
        
        APICaller.shared.fetchDiscoverMoviesWithCombine()
            .sink { completion in
                switch completion {
                case .finished: break;
                case .failure(let error): print(error.localizedDescription); break;
                }
            } receiveValue: { [weak self] movies in
                self?.discoverMovies.send(movies.results)
            }.store(in: &cancellables)
    }
}
