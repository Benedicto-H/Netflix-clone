//
//  Movie.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/19.
//

import Foundation

struct TrendingMoviesResponse: Codable {
    
    // MARK: - Stored-Props
    let page: Int
    let results: [Movie]
    
    // MARK: - Inner Structure
    struct Movie: Codable {
        
        // MARK: - Stored-Props
        let adult: Bool
        let backdrop_path: String?
        let genre_ids: [Int]
        let id: Int
        let media_type: String?
        let original_language: String?
        let original_title: String?
        let overview: String?
        let popularity: Double
        let poster_path: String?
        let release_date: String?
        let title: String?
        let video: Bool
        let vote_average: Double
        let vote_count: Int
    }
}
