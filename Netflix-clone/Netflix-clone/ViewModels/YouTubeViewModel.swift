//
//  YouTubeViewModel.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/08/16.
//

import Foundation
import RxSwift
import RxCocoa

final class YouTubeViewModel {
    
    // MARK: - Stored-Prop
    var youTubeView: PublishSubject<YouTubeDataResponse.VideoElement>
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.youTubeView = PublishSubject<YouTubeDataResponse.VideoElement>.init()
    }
}
