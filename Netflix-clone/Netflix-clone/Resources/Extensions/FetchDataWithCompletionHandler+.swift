//
//  FetchDataWithCompletionHandler+.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/06.
//

import Foundation
import UIKit

extension fetchDataWithCompletionHandler {
    
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
    /// ver. Used API_KEY
    func fetchTrendingMovies(completionHandler: @escaping (Result<[MoviesResponse.Movie], Error>) -> Void) -> Void {
        
        guard let url: URL = URL(string: "\(APICaller.baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { return } //  API_KEY 값의 경우 .xcconfig 파일로 관리
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                let decodedData: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: safeData)
                
                completionHandler(.success(decodedData.results))
            } catch {
                
                completionHandler(.failure(error))
            }
        }.resume()
    }
    
    /// ver. Used ACCESS_TOKEN
    func fetchTrendingMoviesWithToken(completionHandler: @escaping (Result<[MoviesResponse.Movie], Error>) -> Void) -> Void {
        
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
                let decodedData: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: safeData)
                
                completionHandler(.success(decodedData.results))
            } catch {
                
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
