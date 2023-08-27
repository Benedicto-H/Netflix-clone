//
//  YouTubeViewModel.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/08/07.
//

import Foundation
import Combine

final class YouTubeViewModel {
    
    // MARK: - Stored-Prop
    var youTubeView: PassthroughSubject<YouTubeDataResponse.VideoElement, Never>
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        self.youTubeView = .init()
    }
}
