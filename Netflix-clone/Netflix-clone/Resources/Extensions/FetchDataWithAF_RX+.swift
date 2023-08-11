//
//  FetchDataWithAF_RX+.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/08/10.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

extension fetchDataWithAF_RX {
    
    // MARK: - Trending Movies
    func fetchTrendingMoviesWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        //  guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")") else { return }
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/trending/movie/day?language=en-US"
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: APICaller.headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: TMDBMoviesResponse.self) { response in
                switch response.result {
                case .success(let tmdbMovieResponse):
                    observer.onNext(tmdbMovieResponse)
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    observer.onError(error)
                    break;
                }
            }
            
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    // MARK: - Trending TVs
    func fetchTrendingTVsWithAF_RX() -> Observable<TMDBTVsResponse> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/trending/tv/day?language=en-US"
        
        return Observable.create { observser in
            AF.request(url,
                       method: .get,
                       headers: APICaller.headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: TMDBTVsResponse.self) { response in
                switch response.result {
                case .success(let tmdbTVResponse):
                    observser.onNext(tmdbTVResponse)
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    observser.onError(error)
                    break;
                }
            }
            
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    // MARK: - Popular
    func fetchPopularWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/movie/popular?language=en-US&page=1"
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: APICaller.headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: TMDBMoviesResponse.self) { response in
                switch response.result {
                case .success(let tmdbMovieResponse):
                    observer.onNext(tmdbMovieResponse)
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    observer.onError(error)
                    break;
                }
            }
            
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    // MARK: - Upcoming Movies
    func fetchUpcomingMoviesWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/movie/upcoming?anguage=en-US&page=1"
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: APICaller.headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: TMDBMoviesResponse.self) { response in
                switch response.result {
                case .success(let tmdbMovieResponse):
                    observer.onNext(tmdbMovieResponse)
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    observer.onError(error)
                    break;
                }
            }
            
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    // MARK: - Top Rated
    func fetchTopRatedWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/movie/top_rated?language=en-US&page=1"
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: APICaller.headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: TMDBMoviesResponse.self) { response in
                switch response.result {
                case .success(let tmdbMoviesResponse):
                    observer.onNext(tmdbMoviesResponse)
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    observer.onError(error)
                    break;
                }
            }
            
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    // MARK: - Discover Movies
    func fetchDiscoverMoviesWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: APICaller.headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: TMDBMoviesResponse.self) { response in
                switch response.result {
                case .success(let tmdbMoviesResponse):
                    observer.onNext(tmdbMoviesResponse)
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    observer.onError(error)
                    break;
                }
            }
            
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    // MARK: - Search & Query For Details
    func searchWithAF_RX(with query: String) -> Observable<TMDBMoviesResponse> {
        
        guard let query: String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return Observable.error(APICaller.APIError.invalidQueryEncoding) }
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/search/movie?query=\(query)"
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: APICaller.headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: TMDBMoviesResponse.self) { response in
                switch response.result {
                case .success(let tmdbMoviesResponse):
                    observer.onNext(tmdbMoviesResponse)
                    break;
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    observer.onError(error)
                    break;
                }
            }
            
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
}
