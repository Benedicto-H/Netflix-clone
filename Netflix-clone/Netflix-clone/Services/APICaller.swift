//
//  APICaller.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/18.
//

import Foundation
import UIKit
import Combine

final class APICaller {
    
    enum APIError: Error {
        case invalidURL
        case failedResponse
        case failedFetchData
    }
    
    // MARK: - Stored-Props
    static let shared: APICaller = APICaller()  //  -> Singleton Object
    private static let baseURL: String = "https://api.themoviedb.org"
    
    // MARK: - Methods
    // MARK: - Fetch Netflix Symbol
    func fetchNetflixSymbol(completionHandler: @escaping (UIImage) -> Void) -> Void {
        
        let url: String = "https://images.ctfassets.net/y2ske730sjqp/4aEQ1zAUZF5pLSDtfviWjb/ba04f8d5bd01428f6e3803cc6effaf30/Netflix_N.png?w=300" //  source: https://brand.netflix.com/en/assets/logos
        
        guard let url: URL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                let logoImage: UIImage? = UIImage(data: safeData)
                
                DispatchQueue.main.async {
                    
                    completionHandler(logoImage ?? UIImage())
                }
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: - (Temp) Fetch HeroHeaderImage
    func fetchHeroImage(completionHandler: @escaping (UIImage) -> Void) -> Void {
        
        let url: String = "https://occ-0-988-1360.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABX4VbDY-FqCITdF33xEJcP7vZQxu0MLlvhkOTyuEsU4yqZK7NRYb91sHwxmjtXlgxX11NuDB9DgHW0pOLfToPms_n75E6VkDOv3Y.jpg?r=9e3"   //  source: https://www.netflix.com/kr/title/81005126
        
        guard let url: URL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                
                let heroHeaderImage: UIImage? = UIImage(data: safeData)
                
                DispatchQueue.main.async {
                    
                    completionHandler(heroHeaderImage ?? UIImage())
                }
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }.resume()
    }
    // MARK: - Trending Movies
    /// Used API_KEY
    /*
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
     */
    
    /// Used API_KEY    -   Async/Await
    func fetchTrendingMovies() async throws -> MoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { throw APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(from: url)
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.failedResponse }
            
            let decodedData: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APIError.failedFetchData.localizedDescription)
        }
    }
    
    //
    func fetchMovies() -> AnyPublisher<[MoviesResponse.Movie], Error> {
        
        /*
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { return Fail(error: APIError.invalidURL).eraseToAnyPublisher() }
         */
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .compactMap({ $0.data })
            .decode(type: MoviesResponse.self, decoder: JSONDecoder())
            .map({ $0.results })
            .eraseToAnyPublisher()
    }
    
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
    
    // MARK: - Trending TVs
    func fetchTrendingTVs() async throws -> TVsResponse {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/trending/tv/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { throw APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.failedResponse }
            
            let decodedData: TVsResponse = try JSONDecoder().decode(TVsResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Popular
    func fetchPopular() async throws -> MoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/movie/popular?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")&language=en-US&page=1") else { throw APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.failedResponse }
            
            let decodedData: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Upcoming Movies
    func fetchUpcomingMovies() async throws -> MoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/movie/upcoming?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")&language=en-US&page=1") else { throw APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.failedResponse }
            
            let decodedData: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Top Rated
    func fetchTopRated() async throws -> MoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/movie/top_rated?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")&language=en-US&page=1") else { throw APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.failedResponse }
            
            let decodedData: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APIError.failedFetchData.localizedDescription)
        }
    }
    
    // MARK: - Discover Movie
    func fetchDiscoverMovies() async throws -> MoviesResponse {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/discover/movie?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc") else { throw APIError.invalidURL }
        
        do {
            
            let (data, urlResponse): (Data, URLResponse) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.failedResponse }
            
            let decodedData: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
            
            return decodedData
        } catch {
            
            fatalError(APIError.failedFetchData.localizedDescription)
        }
    }
}

extension APICaller {
    
    // MARK: - Fetch Netflix Symbol (-> with. Combine Framework)
    func fetchNetflixSymbolWithCombine() -> AnyPublisher<UIImage, Error> {
        
        let url: String = "https://images.ctfassets.net/y2ske730sjqp/4aEQ1zAUZF5pLSDtfviWjb/ba04f8d5bd01428f6e3803cc6effaf30/Netflix_N.png?w=300"   //  source: https://brand.netflix.com/en/assets/logos
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    
                    throw URLError(.badServerResponse)
                }
                
                return UIImage(data: data) ?? UIImage()
            }
            .mapError({ error -> Error in
                
                return error
            })
            .eraseToAnyPublisher()
    }
}
