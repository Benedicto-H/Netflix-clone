//
//  Content.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/21.
//

import Foundation

struct Content: Codable {
    
    // MARK: - Stored-Props
    var movies: [MoviesResponse.Movie] = []
    var tvs: [TVsResponse.TV] = []
}
