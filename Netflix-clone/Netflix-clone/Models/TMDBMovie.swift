//
//  TMDBMovie.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/19.
//

import Foundation

struct TMDBMoviesResponse: Codable {
    
    // MARK: - Stored-Props
    let page: Int
    let results: [TMDBMovie]
    let total_pages: Int
    let total_results: Int
    
    // MARK: - Inner Structure
    struct TMDBMovie: Codable {
        
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
