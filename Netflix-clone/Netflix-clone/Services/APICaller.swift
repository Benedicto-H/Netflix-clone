//
//  APICaller.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/18.
//

import Foundation

class APICaller {
    
    // MARK: - Stored-Prop (-> Singleton)
    static let shared: APICaller = APICaller()
    
    // MARK: - Method
    func fetchTrendingMovies(completionHandler: @escaping (String) -> Void) -> Void {
        
        let baseURL: String = "https://api.themoviedb.org"
        
        guard let url: URL = URL(string: "\(baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")") else { return }
        
        print("url: \(url) \n")
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            
            guard (urlResponse as? HTTPURLResponse)?.statusCode == 200 else { return }
            
            do {
                
                guard let safeData: Data = data else { return }
                let results: Any = try JSONSerialization.jsonObject(with: safeData, options: .fragmentsAllowed)
                
                dump(results)
            } catch {
                
                fatalError(error.localizedDescription)
            }
        }.resume()
    }
}
