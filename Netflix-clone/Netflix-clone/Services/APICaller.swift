//
//  APICaller.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/18.
//

import Foundation
import UIKit
import Combine

protocol fetchDataWithCompletionHandler {

    // MARK: - Function ProtoTypes
    func fetchNetflixSymbol(completionHandler: @escaping (UIImage) -> Void) -> Void
    func fetchHeroImage(completionHandler: @escaping (UIImage) -> Void) -> Void
}

protocol fetchDataWithCombine {
    
    // MARK: - Function ProtoTypes
    func fetchTrendingMoviesWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error>
    func fetchTrendingTVsWithCombine() -> AnyPublisher<TMDBTVsResponse, Error>
    func fetchPopularWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error>
    func fetchUpcomingMoviesWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error>
    func fetchTopRatedWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error>
    func fetchDiscoverMoviesWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error>
    func searchWithCombine(with query: String) -> AnyPublisher<TMDBMoviesResponse, Error>
    func fetchVideoFromYouTubeWithCombine(with query: String) -> AnyPublisher<YouTubeDataResponse, Error>
}

final class APICaller: fetchDataWithCompletionHandler, fetchDataWithCombine {
    
    enum APIError: String, Error {
        case invalidQueryEncoding = "INVALID QUERY ENCODING ERROR"
        case invalidURL = "INVALID URL ERROR"
        case failedResponse = "FAILED RESPONSE ERROR"
        case failedFetchData = "FAILED FETCH DATA ERROR"
    }
    
    // MARK: - Stored-Props
    static let shared: APICaller = APICaller()  //  -> Singleton Object
    public static let tmdb_baseURL: String = "https://api.themoviedb.org"
    public static let youtube_baseURL: String = "https://www.googleapis.com/youtube/v3/search?"
}
