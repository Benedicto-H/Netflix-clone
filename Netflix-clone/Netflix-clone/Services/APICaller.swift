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
    
    // MARK: - Function ProtoType
    func fetchNetflixSymbol(completionHandler: @escaping (UIImage) -> Void) -> Void
    func fetchHeroImage(completionHandler: @escaping (UIImage) -> Void) -> Void
    func fetchTrendingMovies(completionHandler: @escaping (Result<[MoviesResponse.Movie], Error>) -> Void) -> Void
    func fetchTrendingMoviesWithToken(completionHandler: @escaping (Result<[MoviesResponse.Movie], Error>) -> Void) -> Void
}

protocol fetchDataWithConcurrency {
    
    // MARK: - Function ProtoType
    func fetchTrendingMovies() async throws -> MoviesResponse
    func fetchTrendingMoviesWithToken() async throws -> MoviesResponse
    func fetchTrendingTVs() async throws -> TVsResponse
    func fetchPopular() async throws -> MoviesResponse
    func fetchUpcomingMovies() async throws -> MoviesResponse
    func fetchTopRated() async throws -> MoviesResponse
    func fetchDiscoverMovies() async throws -> MoviesResponse
}

protocol fetchDataWithCombine {
    
    // MARK: - Function ProtoType
    func fetchNetflixSymbolWithCombine() -> AnyPublisher<UIImage, Error>
}

final class APICaller: fetchDataWithCompletionHandler, fetchDataWithConcurrency, fetchDataWithCombine {
    
    enum APIError: Error {
        case invalidURL
        case failedResponse
        case failedFetchData
    }
    
    // MARK: - Stored-Props
    static let shared: APICaller = APICaller()  //  -> Singleton Object
    public static let baseURL: String = "https://api.themoviedb.org"
}
