//
//  Response.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/21.
//

import Foundation

struct Response {
    
    // MARK: - Stored-Props
    var movie: MoviesResponse? = nil
    var tv: TVsResponse? = nil
    
    /*
    init() {
        
        self.movie = nil
        self.tv = nil
    }
     */
    
    /*
    init(movies: MoviesResponse? = nil, tvs: TVsResponse? = nil) {
        self.movies = movies
        self.tvs = tvs
    }
     */
}

/*
 Task {
             
             do {
                 
                 switch indexPath.section {
                 case Sections.TrendingMovies.rawValue:
                     
                     let trendingMovies: TrendingMoviesResponse? = try await APICaller.shared.fetchTrendingMovies()
                     
                     cell.configure(with: [Cinema(movies: trendingMovies?.results)])
                     break;
                     
                 case Sections.TrendingTV.rawValue:
                     
                     let trendingTVs: TrendingTVsResponse? = try await APICaller.shared.fetchTrendingTVs()
                     
                     cell.configure(with: [Cinema(tvs: trendingTVs.results)])
                     break;
                     
                 case Sections.Popular.rawValue:
                     
                     let popular: TrendingMoviesResponse? = try await APICaller.shared.fetchPopular()
                     
                     cell.configure(with: [Cinema(movies: popular.results)])
                     break;
                     
                 case Sections.UpcomingMovies.rawValue:
                     
                     let upcomingMovies: TrendingMoviesResponse? = try await APICaller.shared.fetchUpcomingMovies()
                     
                     cell.configure(with: [Cinema(movies: upcomingMovies.results)])
                     break;
                     
                 case Sections.TopRated.rawValue:
                     
                     let topRated: TrendingMoviesResponse? = try await APICaller.shared.fetchTopRated()
                     
                     cell.configure(with: [Cinema(movies: topRated.results)])
                     break;
                     
                 default:
                     break;
                     //  return UITableViewCell()
                 }
             } catch {
                 
                 fatalError(error.localizedDescription)
             }
             
             return UITableViewCell()
         }
 */
