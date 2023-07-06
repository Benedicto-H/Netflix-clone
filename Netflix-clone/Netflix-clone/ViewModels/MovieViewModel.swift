//
//  MovieViewModel.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/25.
//

import Foundation
import Combine

struct MovieViewModel {
    
    // MARK: - Stored-Props
    let titleName: String
    let posterURL: String
}

class ViewModel {
    
    let movies: CurrentValueSubject<MoviesResponse?, Error> = .init(nil)
    let tvs: CurrentValueSubject<TVsResponse?, Error> = .init(nil)
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        
    }
}
