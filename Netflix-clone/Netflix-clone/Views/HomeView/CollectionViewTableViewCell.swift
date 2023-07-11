//
//  CollectionViewTableViewCell.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/11.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    // MARK: - Stored-Props
    static let identifier: String = "CollectionViewTableViewCell"   //  -> Singleton
    
    private var tmdbMovies: [TMDBMoviesResponse.TMDBMovie] = [TMDBMoviesResponse.TMDBMovie]()
    private var tmdbTvs: [TMDBTVsResponse.TMDBTV] = [TMDBTVsResponse.TMDBTV]()
    
    // MARK: - Custom View
    private let collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        //  layout.itemSize = CGSize(width: 120, height: 200)
        /// UICollectionViewDelegateFlowLayout - (optional) Method
        /// func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {    //  NSCoding - (Required) Method
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    
    public func configure(withTMDBMovies movies: [TMDBMoviesResponse.TMDBMovie]?, withTMDBTVs tvs: [TMDBTVsResponse.TMDBTV]?) -> Void {
        
        self.tmdbMovies = movies ?? []
        self.tmdbTvs = tvs ?? []
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegateFlowLayout - (optional) Method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (contentView.frame.size.width) / 3, height: contentView.frame.size.height)
    }
    
    // MARK: - UICollectionViewDelegate - (Optional) Method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //  Movies
        if (indexPath.row < tmdbMovies.count) {
            
            guard let tmdbMovieName: String = tmdbMovies[indexPath.row].original_title else { return }
            
            Task {
                
                do {
                    
                    let responseMovieData: YouTubeDataResponse = try await APICaller.shared.fetchVideoFromYouTube(with: tmdbMovieName + " trailer")
                    
                    print("responseMovieData: \(responseMovieData.items[0].id) \n")
                } catch {
                    
                    fatalError(error.localizedDescription)
                }
            }
        }
        
        //  TVs
        if (indexPath.row < tmdbTvs.count) {
            
            guard let tmdbTVName: String = tmdbTvs[indexPath.row].original_name else { return }
            
            Task {
                
                do {
                    
                    let responseTVData: YouTubeDataResponse = try await APICaller.shared.fetchVideoFromYouTube(with: tmdbTVName + " trailer")
                    
                    print("responseTVData: \(responseTVData.items[0].id) \n")
                } catch {
                    
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource - (Required) Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return max(tmdbMovies.count, tmdbTvs.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .systemBackground
        
        if (indexPath.row < tmdbMovies.count) {
            
            cell.configure(with: tmdbMovies[indexPath.row].poster_path ?? "")
        }
        
        if (indexPath.row < tmdbTvs.count) {
            
            cell.configure(with: tmdbTvs[indexPath.row].poster_path ?? "")
        }
        
        return cell
    }
}
