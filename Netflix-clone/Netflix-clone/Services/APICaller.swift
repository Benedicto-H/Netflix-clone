//
//  APICaller.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/18.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
import RxCocoa

protocol fetchDataWithCompletionHandler {
    
    // MARK: - Function ProtoTypes
    func fetchNetflixSymbol(completionHandler: @escaping (UIImage) -> Void) -> Void
    func fetchHeroImage(completionHandler: @escaping (UIImage) -> Void) -> Void
}

protocol fetchDataWithAF_RX {
    
    // MARK: - Function ProtoTypes
    func fetchTrendingMoviesWithAF_RX() -> Observable<TMDBMoviesResponse>
    func fetchTrendingTVsWithAF_RX() -> Observable<TMDBTVsResponse>
    func fetchPopularWithAF_RX() -> Observable<TMDBMoviesResponse>
    func fetchUpcomingMoviesWithAF_RX() -> Observable<TMDBMoviesResponse>
    func fetchTopRatedWithAF_RX() -> Observable<TMDBMoviesResponse>
    func fetchDiscoverMoviesWithAF_RX() -> Observable<TMDBMoviesResponse>
    func searchWithAF_RX(with query: String) -> Observable<TMDBMoviesResponse>
    func fetchVideoFromYouTubeWithAF_RX(with query: String) -> Observable<YouTubeDataResponse>
}

final class APICaller: fetchDataWithCompletionHandler, fetchDataWithAF_RX {
    
    enum APIError: String, Error {
        case invalidQueryEncoding = "INVALID QUERY ENCODING ERROR"
        case invalidURL = "INVALID URL ERROR"
        case failedResponse = "FAILED RESPONSE ERROR"
        case failedFetchData = "FAILED FETCH DATA ERROR"
    }
    
    // MARK: - Stored-Props
    static let shared: APICaller = APICaller()  //  -> Singleton Object
    public static let headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer \(Bundle.main.object(forInfoDictionaryKey: "TMDB_ACCESS_TOKEN") as? String ?? "")"
    ]
    public static let tmdb_baseURL: String = "https://api.themoviedb.org"
    public static let youtube_baseURL: String = "https://www.googleapis.com/youtube/v3/search?"
}
