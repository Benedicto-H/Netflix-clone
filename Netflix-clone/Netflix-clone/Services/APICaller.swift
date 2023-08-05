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

protocol fetchDataWithConcurrency {
    
    // MARK: - Function ProtoTypes
    func fetchTrendingMovies() async throws -> TMDBMoviesResponse
    func fetchTrendingTVs() async throws -> TMDBTVsResponse
    func fetchPopular() async throws -> TMDBMoviesResponse
    func fetchUpcomingMovies() async throws -> TMDBMoviesResponse
    func fetchTopRated() async throws -> TMDBMoviesResponse
    func fetchDiscoverMovies() async throws -> TMDBMoviesResponse
}

final class APICaller: fetchDataWithCompletionHandler, fetchDataWithConcurrency {
    
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
