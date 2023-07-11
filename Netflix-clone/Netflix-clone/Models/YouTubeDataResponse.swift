//
//  YouTubeDataResponse.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/10.
//

import Foundation

struct YouTubeDataResponse: Codable {   //  YoutubeSearchResponse
    
    // MARK: - Stored-Props
    let etag: String?
    let items: [VideoElement]
    
    // MARK: - Inner Structure
    struct VideoElement: Codable {  //  VideoElement
        
        // MARK: - Stored-Props
        let etag: String?
        let id: Element
        let kind: String?
        
        // MARK: - Inner Structure
        struct Element: Codable {    //  IdVideoElement
            
            // MARK: - Stored-Props
            let kind: String?
            let videoId: String?
        }
    }
}
