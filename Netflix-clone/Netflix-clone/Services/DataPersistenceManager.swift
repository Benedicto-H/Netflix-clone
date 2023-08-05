//
//  DataPersistenceManager.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/07/14.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    // MARK: - Stored-Props
    static let shared: DataPersistenceManager = DataPersistenceManager()  //  ->  Singleton
    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //  let context = Entity가 들어있는 Persistent Container에 직접적으로 접근할 수 없어, temporary area (= 임시 영역) 인 context를 참조 변수를 생성
    //  -> 모든 Data의 C.R.U.D는 context 영역에서 발생!
    
    //  Persistent Container에 직접적인 접근이 불가능한 이유
    /// 1. 추상화 계층: CoreData는 데이터베이스와 상호작용하는 복잡한 로직을 숨기기 위해 추상화 계층을 사용합니다.
    /// Persistent Container는 이러한 추상화 계층의 일부로, 데이터의 실제 저장소를 추상화하고
    /// 관리하는 역할을 합니다. 이렇게 함으로써 CoreData는 여러 데이터 저장소 백엔드를 지원하고
    /// 애플리케이션의 데이터 모델과 상호작용하는 일관된 인터페이스를 제공할 수 있습니다.
    ///
    /// 2. 데이터 무결성 보장: CoreData는 데이터의 무결성을 보장하기 위해 여러 가지 내부 작업을 수행합니다.
    /// Persistent Container는 이러한 작업을 수행하는 중요한 요소 중 하나입니다. 직접적인 접근이
    /// 허용된다면, 애플리케이션이 데이터를 잘못 조작하거나 무결성 규칙을 우회할 수 있으며, 데이터의
    /// 일관성과 안정성이 손상될 수 있습니다.
    ///
    /// 3. 데이터베이스 연결 관리: Persistent Container는 데이터베이스 연결을 관리하고 최적화합니다.
    /// 데이터베이스 연결을 효율적으로 관리하고 여러 스레드에서 동시에 액세스하는 경우에도 일관성을 유지하기
    /// 위해 내부적으로 작업을 처리합니다. 직접적인 접근이 허용된다면, 이러한 작업을 처리하지 않고
    /// 데이터베이스와의 일관성을 유지하기가 어려울 수 있습니다.
    private let request: NSFetchRequest<TMDBMovieItem> = TMDBMovieItem.fetchRequest()
    
    // MARK: - Methods
    func downloadMovieWith(model: TMDBMoviesResponse.TMDBMovie, completionHandler: @escaping (Result<Void, Error>) -> Void) -> Void {
        
        let item: TMDBMovieItem = TMDBMovieItem(context: context)
        
        item.adult = model.adult
        item.backdrop_path = model.backdrop_path
        item.genre_ids = model.genre_ids
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.original_title = model.original_title
        item.overview = model.overview
        item.popularity = model.popularity
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.title = model.title
        item.video = model.video
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            
            completionHandler(.success(()))
        } catch {
            print("error: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
            
            completionHandler(.failure(DataPersistenceManager.DatabaseError.failedToSaveData))
        }
    }
    
    func fetchMovieFromContext(completionHandler: @escaping (Result<[TMDBMovieItem], Error>) -> Void) -> Void {
        
        do {
            let movies: [TMDBMovieItem] = try context.fetch(request)
            
            completionHandler(.success(movies))
        } catch {
            print("error: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
            
            completionHandler(.failure(DataPersistenceManager.DatabaseError.failedToFetchData))
        }
    }
    
    func deleteMovieWith(model: TMDBMovieItem, completionHandler: @escaping (Result<Void, Error>) -> Void) -> Void {
        
        context.delete(model)
        
        do {
            try context.save()
            
            completionHandler(.success(()))
        } catch {
            print("error: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
            
            completionHandler(.failure(DataPersistenceManager.DatabaseError.failedToDeleteData))
        }
    }
}
