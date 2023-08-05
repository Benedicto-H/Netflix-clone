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
    func fetchVideoFromYouTube(with query: String) async throws -> YouTubeDataResponse {
        
        //  For example..
        print("Before query value: \(query)")   //  ex) Avengers Endgame
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw APICaller.APIError.invalidQueryEncoding }
        
        print("After query value: \(query) \n")    //  ex) Avengers%20Endgame
        
        guard let url: URL = URL(string: "\(APICaller.youtube_baseURL)q=\(query)&key=\(Bundle.main.object(forInfoDictionaryKey: "GOOGLE_DEVELOPER_API_KEY") as? String ?? "")") else { throw APICaller.APIError.invalidURL }
        
        do {
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APICaller.APIError.failedResponse }
            
            //  let decodedData: Any = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            
            //  print(decodedData)
            
            let decodedData: YouTubeDataResponse = try JSONDecoder().decode(YouTubeDataResponse.self, from: data)
            
            return decodedData
        } catch {
            fatalError(APICaller.APIError.failedFetchData.localizedDescription)
        }
    }
}
