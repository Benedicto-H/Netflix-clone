//
//  FetchDataWithCompletionHandler+.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/06.
//

import Foundation
import UIKit
import Alamofire

extension fetchDataWithCompletionHandler {
    
    // MARK: - Fetch Netflix Symbol
    func fetchNetflixSymbol(completionHandler: @escaping (UIImage) -> Void) -> Void {
        
        let url: String = "https://images.ctfassets.net/y2ske730sjqp/4aEQ1zAUZF5pLSDtfviWjb/ba04f8d5bd01428f6e3803cc6effaf30/Netflix_N.png?w=300" //  source: https://brand.netflix.com/en/assets/logos
        
        AF.request(url)
            .validate(statusCode: 200 ..< 300)
            .response { afDataResponse in
                switch afDataResponse.result {
                case .success(let data):
                    if let safeData: Data = data {
                        let symbolImage: UIImage? = UIImage(data: safeData)

                        DispatchQueue.main.async {
                            completionHandler(symbolImage ?? UIImage())
                        }
                    }
                    break;
                case .failure(let error): fatalError(error.localizedDescription); break;
                }
            }
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
    func fetchTrendingMovies(completionHandler: @escaping (Result<[TMDBMoviesResponse.TMDBMovie], Error>) -> Void) -> Void {
        
        guard let url: URL = URL(string: "\(APICaller.tmdb_baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")") else { return } //  API_KEY 값의 경우 .xcconfig 파일로 관리
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                guard let safeData: Data = data else { return }
                let decodedData: TMDBMoviesResponse = try JSONDecoder().decode(TMDBMoviesResponse.self, from: safeData)
                
                completionHandler(.success(decodedData.results))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
