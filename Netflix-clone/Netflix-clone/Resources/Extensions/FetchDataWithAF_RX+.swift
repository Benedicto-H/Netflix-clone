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
        
        /// Observable<Element>는 Publisher ( or AnyPublisher)와 유사
        return Observable.create { observer in
            let url: String = "\(APICaller.tmdb_baseURL)/3/trending/movie/day?language=en-US"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url, method: .get, headers: APICaller.headers)
                .validate(statusCode: 200 ..< 300)  //  200 ~ 300 사이의 상태코드만 허용
                .validate(contentType: ["application/json"])    //  JSON 포맷형식만 허용
                .responseDecodable(of: TMDBMoviesResponse.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(movieResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))    //  ->  .receive(on: DispatchQueue.global(qos: .background))
        .asObservable() //  ->  .eraseToAnyPublisher()
    }
    
    // MARK: - Trending TVs
    func fetchTrendingTVsWithAF_RX() -> Observable<TMDBTVsResponse> {
        
        return Observable.create { observer in
            let url: String = "\(APICaller.tmdb_baseURL)/3/trending/tv/day?language=en-US"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url, method: .get, headers: APICaller.headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: TMDBTVsResponse.self) { response in
                    switch response.result {
                    case .success(let tvResponse):
                        observer.onNext(tvResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
    
    // MARK: - Popular
    func fetchPopularWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        return Observable.create { observer in
            let url: String = "\(APICaller.tmdb_baseURL)/3/movie/popular?language=en-US&page=1"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url, method: .get, headers: APICaller.headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: TMDBMoviesResponse.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(movieResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
    
    // MARK: - Upcoming Movies
    func fetchUpcomingMoviesWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        return Observable.create { observer in
            let url: String = "\(APICaller.tmdb_baseURL)/3/movie/upcoming?language=en-US&page=1"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url, method: .get, headers: APICaller.headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: TMDBMoviesResponse.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(movieResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
    
    // MARK: - Top Rated
    func fetchTopRatedWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        return Observable.create { observer in
            let url: String = "\(APICaller.tmdb_baseURL)/3/movie/top_rated?language=en-US&page=1"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url, method: .get, headers: APICaller.headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: TMDBMoviesResponse.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(movieResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
    
    // MARK: - Discover Movies
    func fetchDiscoverMoviesWithAF_RX() -> Observable<TMDBMoviesResponse> {
        
        return Observable.create { observer in
            let url: String = "\(APICaller.tmdb_baseURL)/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url, method: .get, headers: APICaller.headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: TMDBMoviesResponse.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(movieResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
    
    // MARK: - Search & Query For Details
    func searchWithAF_RX(with query: String) -> Observable<TMDBMoviesResponse> {
        
        return Observable.create { observer in
            guard let query: String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { observer.onError(APICaller.APIError.invalidQueryEncoding); return Disposables.create() }
            
            let url: String = "\(APICaller.tmdb_baseURL)/3/search/movie?query=\(query)&include_adult=false&language=en-US&page=1"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url, method: .get, headers: APICaller.headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: TMDBMoviesResponse.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(movieResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
    
    // MARK: - Fetch Movie
    func fetchVideoFromYouTubeWithAF_RX(with query: String) -> Observable<YouTubeDataResponse> {
        
        return Observable.create { observer in
            guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { observer.onError(APICaller.APIError.invalidQueryEncoding); return Disposables.create() }
            
            let url: String = "\(APICaller.youtube_baseURL)q=\(query)&key=\(Bundle.main.object(forInfoDictionaryKey: "GOOGLE_DEVELOPER_API_KEY") as? String ?? "")"
            
            guard let url: URL = URL(string: url) else { observer.onError(URLError(.badURL)); return Disposables.create() }
            
            AF.request(url)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: YouTubeDataResponse.self) { response in
                    switch response.result {
                    case .success(let youTubeResponse):
                        observer.onNext(youTubeResponse)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
    }
}
