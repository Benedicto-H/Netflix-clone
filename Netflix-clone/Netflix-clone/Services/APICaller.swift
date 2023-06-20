//
//  APICaller.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/18.
//

import Foundation

enum APIError: Error {
    case failedFetchData
}

class APICaller {
    
    // MARK: - Stored-Prop (-> Singleton)
    static let shared: APICaller = APICaller()
    private static let baseURL: String = "https://api.themoviedb.org"
    
    // MARK: - Methods
    
    /// Used API_KEY
    func fetchTrendingMovies(completionHandler: @escaping (Result<[TrendingMoviesResponse.Movie], Error>) -> Void) -> Void {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { return } //  API_KEY 값의 경우 .xcconfig 파일로 관리
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                let decodedData: TrendingMoviesResponse = try JSONDecoder().decode(TrendingMoviesResponse.self, from: safeData)
                
                completionHandler(.success(decodedData.results))
            } catch {
                
                completionHandler(.failure(error))
            }
        }.resume()
    }
    
    /// Used API_KEY    -   Async/Await
    /*
    func fetchTrendingMovies() async throws -> TrendingMoviesResponse? {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { return nil }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(from: url)
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            
            let decodedData: TrendingMoviesResponse = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(error.localizedDescription)
        }
    }
     */
    
    /// Used ACCESS_TOKEN
    /*
    func fetchTrendingMovies(completionHandler: @escaping (Result<[TrendingMoviesResponse.Movie], Error>) -> Void) -> Void {
        
        let headers: [String : String] = [
            "accept": "application/json",
            "Authorization": "Bearer \(Bundle.main.object(forInfoDictionaryKey: "ACCESS_TOKEN") as? String ?? "")"
        ]   //  ACCESS_TOKEN 값의 경우 .xcconfig 파일로 분리
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: "\(APICaller.baseURL)/3/trending/movie/day?languages=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                let decodedData: TrendingMoviesResponse = try JSONDecoder().decode(TrendingMoviesResponse.self, from: safeData)
                
                completionHandler(.success(decodedData.results))
            } catch {
                
                completionHandler(.failure(error))
            }
        }.resume()
    }
     */
    
    /// Used ACCESS_TOKEN   -   Async/Await
    /*
    func fetchTrendingMovies() async throws -> TrendingMoviesResponse? {
        
        let headers: [String : String] = [
            "accept": "application/json",
            "Authorization": "Bearer \(Bundle.main.object(forInfoDictionaryKey: "ACCESS_TOKEN") as? String ?? "")"
        ]
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: "\(APICaller.baseURL)/3/trending/movie/day?languages=en-US")! as URL,
                                                               cachePolicy: .useProtocolCachePolicy,
                                                               timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: request as URLRequest)
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            
            let decodedData: TrendingMoviesResponse = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(error.localizedDescription)
        }
    }
     */
}
