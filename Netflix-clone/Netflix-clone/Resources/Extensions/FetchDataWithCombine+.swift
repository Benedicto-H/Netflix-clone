//
//  FetchDataWithCombine+.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/06.
//

import Foundation
import UIKit
import Combine

extension fetchDataWithCombine {
    
    // MARK: - Fetch Netflix Symbol (-> with. Combine Framework)
    func fetchNetflixSymbolWithCombine() -> AnyPublisher<UIImage, Error> {
        
        let url: String = "https://images.ctfassets.net/y2ske730sjqp/4aEQ1zAUZF5pLSDtfviWjb/ba04f8d5bd01428f6e3803cc6effaf30/Netflix_N.png?w=300"   //  source: https://brand.netflix.com/en/assets/logos
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
                
                return UIImage(data: data) ?? UIImage()
            }
            .mapError({ error -> Error in
                
                return error
            })
            .eraseToAnyPublisher()  //  eraseToAnyPublisher(): 지금까지의 data stream이 어떠했든 간에 '최종적인 형태의 Publisher (즉, AnyPublisher)' 로 return
    }
    
    func fetchHeroImageWithCombine() -> AnyPublisher<UIImage, Error> {
        
        let url: String = "https://occ-0-988-1360.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABX4VbDY-FqCITdF33xEJcP7vZQxu0MLlvhkOTyuEsU4yqZK7NRYb91sHwxmjtXlgxX11NuDB9DgHW0pOLfToPms_n75E6VkDOv3Y.jpg?r=9e3"   //  source: https://www.netflix.com/kr/title/81005126
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
                
                return UIImage(data: data) ?? UIImage()
            }
            .mapError({ error -> Error in
                
                return error
            })
            .eraseToAnyPublisher()
    }
}
