//
//  FetchDataWithCombine+.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/08/07.
//

import Foundation
import UIKit
import Combine

extension fetchDataWithCombine {
    
    // MARK: - Trending Movies
    func fetchTrendingMoviesWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/trending/movie/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")"
        
        guard let url: URL = URL(string: url) else {
            print("URLError.badURL: \(URLError(.badURL))") //  URLError(_nsError: Error Domain=NSURLErrorDomain Code=-1000 "(null)")
            print("URLError.badURL.localizedDescription: \(URLError(.badURL).localizedDescription)")    //  The operation couldn’t be completed. (NSURLErrorDomain error -1000.)
            
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }  //  URL이 유효한지 Optional Binding을 통해 확인하여 유효하면 pass, 그렇지 않으면 URLError(.badURL)을 방출하는 Fail Publisher를 transmit
        
        //  Before
        /*
        return URLSession.shared.dataTaskPublisher(for: url)    //  .dataTaskPublisher()를 통해 데이터를 가져오는데
            .receive(on: DispatchQueue.main)    //  데이터를 받는 DispatchQueue를 main으로 설정하여 UI 업데이트를 수행할 수 있도록
            .compactMap({ output in //  .compactMap -> Transform Operator
                
                return output.data  /// output: URLSession.DataTaskPublisher.Output
            })  /// eq: .compactMap({ $0.data })    ->  .compactMap() Operator를 통해 nil이 아닌 값만 반환
            .catch({ error in   //  .catch -> Error Handling Operator
                                //  .catch() Operator를 통해 에러가 발생한 경우,
                return Fail(error: error).eraseToAnyPublisher() //  에러를 포함하는 Fail Publisher를 return하여 transmit
            })
            .decode(type: TMDBMoviesResponse.self, decoder: JSONDecoder())  //  데이터를 Decoding 하여 TMDBMoviesResponse 객체로 return
            .eraseToAnyPublisher()  //  .eraseToAnyPublisher() 메서드로 Publisher의 타입을 AnyPublisher<TMDBMoviesResponse, Error>로 지정하고 반환
         */
        
        //  After
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let response: HTTPURLResponse = element.response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                    //  '200 ..< 300 ~= response.statusCode' -> Range Operator (..<)와 Pattern Matching Operator (~=) 을 조합하여 200부터 299까지의 범위에 속하는가
                    throw URLError(.badURL)
                }
                
                //  print("output.data: \(element.data)")
                
                return element.data
            }
            .decode(type: TMDBMoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        /// `.receive(on:)` 연산자 순서가 중요!
        /// ->  `.receive(on:)` 연산자는 이후에 호출되는 연산자들이 처리되는 DispatchQueue(Thread)를 지정함
        ///
        /// ver. Before: `.receive(on:)` 연산자를 앞쪽에 둔 경우
        /// Data를 fetch 하는 작업부터 UI 업데이트가 Main Thread에서 처리됨
        /// (-> Data를 가져오는 작업 자체부터 Main thread에서 실행되므로, UI 업데이트를 기다리지 않고 즉시 UI를 업데이트할 수 있음)
        ///
        /// ver. After: `.receive(on:)` 연산자를 뒤쪽에 둔 경우
        /// Data가 모두 처리된 후에 UI 업데이트가 Main Thread에서 처리됨
        /// (-> 비동기 작업을 Background Thread에서 실행하고, 모든 처리가 완료된 후에 UI 업데이트를 Main Thread에서 수행)
        ///
        /// 기본적으로, UI 업데이트는 Main Thread에서만 이루어지기에 비동기로 Data를 fetch 하는 작업은 Background Thread에서 이루어져야함!   (->  ver. After가 더 맞는 방법임)
        ///
        /// `Data를 fetch 하는 작업은 Background Thread에서 이루어져야 하는 이유`
        /// 1. `UI Responsiveness (UI 반응성)`: 데이터를 가져오는 작업은 네트워크 요청과 파일 I/O 등의 I/O 작업을 포함할 수 있습니다. 이러한 작업은 일반적으로 시간이 걸리기 때문에 메인 스레드에서 수행하면 UI의 응답성이 떨어질 수 있습니다. 사용자가 앱을 조작하고 있는 동안 UI가 끊기거나 멈추는 것은 좋지 않은 사용자 경험이 될 수 있습니다.
        /// 2. `앱 성능`: 메인 스레드에서 무거운 작업을 수행하면 앱의 성능이 저하될 수 있습니다. 메인 스레드는 UI 이벤트 처리와 애니메이션 등 앱의 주요 사용자 인터페이스를 관리해야 하는데, 무거운 작업을 처리하면 UI의 반응성이 떨어질 뿐만 아니라 화면 갱신이 느려질 수 있습니다.
        ///
        /// `ver. Before`의 문제점
        /// 1. `UI Blocking (UI 차단)`: 데이터를 가져오는 작업이 메인 스레드에서 실행되면 해당 작업이 끝날 때까지 메인 스레드가 차단됩니다. 이는 사용자의 모든 입력과 화면 갱신을 중단시키는 결과를 가져올 수 있으며, 앱의 반응성을 크게 저하시킵니다.
        /// 2. `Crash (앱 비정상 종료)`: iOS에서는 메인 스레드에서 네트워크 요청을 보내는 것을 금지하고 있습니다. 만약 메인 스레드에서 네트워크 요청을 수행한다면 앱이 비정상적으로 종료될 수 있습니다.
    }
    
    // MARK: - Trending TVs
    func fetchTrendingTVsWithCombine() -> AnyPublisher<TMDBTVsResponse, Error> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/trending/tv/day?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")"
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
        /*
            .compactMap({ output -> Data in
                return output.data
            })
         */
            .tryMap({ output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            })
            .decode(type: TMDBTVsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Popular
    func fetchPopularWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/movie/popular?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&language=en-US&page=1"
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            })
            .decode(type: TMDBMoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Upcoming Movies
    func fetchUpcomingMoviesWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/movie/upcoming?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&language=en-US&page=1"
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            })
            .decode(type: TMDBMoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Top Rated
    func fetchTopRatedWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/movie/top_rated?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&language=en-US&page=1"
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            })
            .decode(type: TMDBMoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Discover Movies
    func fetchDiscoverMoviesWithCombine() -> AnyPublisher<TMDBMoviesResponse, Error> {
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/discover/movie?api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc"
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            })
            .decode(type: TMDBMoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search & Query For Details
    func searchWithCombine(with query: String) -> AnyPublisher<TMDBMoviesResponse, Error> {
        
        guard let query: String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return Fail(error: APICaller.APIError.invalidQueryEncoding).eraseToAnyPublisher() }
        
        let url: String = "\(APICaller.tmdb_baseURL)/3/search/movie?query=\(query)&api_key=\(Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? "")"
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            })
            .decode(type: TMDBMoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Movie From Youtube
    func fetchVideoFromYouTubeWithCombine(with query: String) -> AnyPublisher<YouTubeDataResponse, Error> {
        
        guard let query: String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return Fail(error: APICaller.APIError.invalidQueryEncoding).eraseToAnyPublisher() }
        
        let url: String = "\(APICaller.youtube_baseURL)q=\(query)&key=\(Bundle.main.object(forInfoDictionaryKey: "GOOGLE_DEVELOPER_API_KEY") as? String ?? "")"
        
        guard let url: URL = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            })
            .decode(type: YouTubeDataResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
