//
//  FetchDataWithConcurrency+.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/06.
//

import Foundation
import UIKit

extension fetchDataWithConcurrency {
    
    // MARK: - Trending Movies
    /// ver. Used API_KEY
    func fetchTrendingMovies() async throws -> TMDBMoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(from: url)
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
    
    /// ver. Used ACCESS_TOKEN
    func fetchTrendingMoviesWithToken() async throws -> TMDBMoviesResponse {
        
        let headers: [String : String] = [
            "accept": "application/json",
            "Authorization": "Bearer \(Bundle.main.object(forInfoDictionaryKey: "TMDB_ACCESS_TOKEN") as? String ?? "")"
        ]
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: "\(APICaller.tmdb_baseURL)/3/trending/movie/day?languages=en-US")! as URL,
                                                               cachePolicy: .useProtocolCachePolicy,
                                                               timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: request as URLRequest)
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Trending TVs
    func fetchTrendingTVs() async throws -> TMDBTVsResponse {
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/trending/tv/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBTVsResponse = try JSONDecoder().decode(TMDBTVsResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Popular
    func fetchPopular() async throws -> TMDBMoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/movie/popular?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&language=en-US&page=1") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Upcoming Movies
    func fetchUpcomingMovies() async throws -> TMDBMoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/movie/upcoming?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&language=en-US&page=1") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Top Rated
    func fetchTopRated() async throws -> TMDBMoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/movie/top_rated?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&language=en-US&page=1") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Discover Movies
    func fetchDiscoverMovies() async throws -> TMDBMoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/discover/movie?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Search & Query For Details
    func search(with query: String) async throws -> TMDBMoviesResponse {
        
        print("Before query value: \(query)")
        
        guard let query: String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw APICaller.APIError.invalidQueryEncoding }
        
        print("After query value: \(query) \n")
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/search/movie?query=\(query)&api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Fetch Movie
    func fetchMovieFromYouTube(with query: String) async throws -> YouTubeDataResponse {
        
        //  For example..
        print("Before query value: \(query)")   //  Avengers Endgame
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw APICaller.APIError.invalidQueryEncoding }
        
        print("After query value: \(query) \n")    //  Avengers%20Endgame
        
        guard let url: URL = URL(string: "\(APICaller.youtube_baseURL)q=\(query)&key=\(Bundle.main.object(forInfoDictionaryKey: "GOOGLE_DEVELOPER_API_KEY") as? String ?? "")") else { throw APICaller.APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            //  let decodedData: Any = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            
            //  print(decodedData)
            
            let decodedData: YouTubeDataResponse = try JSONDecoder().decode(YouTubeDataResponse.self, from: data)
            
            //  dump(decodedData)
            print("\(decodedData) \n")
            
            print(decodedData.items[0].id)
            
            return decodedData
        } catch {
            
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
}
