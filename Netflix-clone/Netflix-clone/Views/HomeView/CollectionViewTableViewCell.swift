//
//  CollectionViewTableViewCell.swift
//  Netflix-clone
//
//  Created by 홍진표 on 2023/06/11.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    
    // MARK: - Function ProtoType
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: Any) -> Void
}

class CollectionViewTableViewCell: UITableViewCell {

    // MARK: - Stored-Props
    static let identifier: String = "CollectionViewTableViewCell"   //  -> Singleton
    weak var delegate: CollectionViewTableViewCellDelegate? //  -> Dependency Injection
    
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
        
        //  contentView.backgroundColor = .systemBackground
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
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadMovieAt(indexPaths: [IndexPath]) -> Void {
        
        for indexPath in indexPaths {
            print("Downloading \(tmdbMovies[indexPath.row].original_title ?? "")")
            
            DataPersistenceManager.shared.downloadMovieWith(model: tmdbMovies[indexPath.row]) { result in
                
                switch result {
                case .success():
                    
                    print("Downloaded To Database")
                    
                    NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                    break;
                    
                case .failure(let error):
                    
                    print("error: \(error.localizedDescription)")
                    fatalError(error.localizedDescription)
                    break;
                    
                default:
                    break;
                }
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegateFlowLayout - (optional) Method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (contentView.frame.size.width) / 3, height: contentView.frame.size.height)
    }
    
    // MARK: - UICollectionViewDelegate - (Optional) Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //  Movies
        if (indexPath.row < tmdbMovies.count) {
            guard let tmdbMovieName: String = tmdbMovies[indexPath.row].original_title else { return }
            
            Task {
                do {
                    let responseData: YouTubeDataResponse = try await APICaller.shared.fetchVideoFromYouTube(with: tmdbMovieName + " trailer")
                    
                    self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: PreviewViewModel(title: tmdbMovieName, youTubeView: responseData.items[0], overview: tmdbMovies[indexPath.row].overview ?? ""))
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
                    let responseData: YouTubeDataResponse = try await APICaller.shared.fetchVideoFromYouTube(with: tmdbTVName + " trailer")
                    
                    print("responseData: \(responseData.items[0].id) \n")
                    
                    delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: PreviewViewModel(title: tmdbTVName, youTubeView: responseData.items[0], overview: tmdbTvs[indexPath.row].overview ?? ""))
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    //  iOS 13.0–16.0 Deprecated
    /// optional func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config: UIContextMenuConfiguration = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _ in
            let downloadAction = UIAction(
                title: "Download",
                subtitle: nil,
                image: nil,
                identifier: nil,
                discoverabilityTitle: nil,
                state: .off) { [weak self] _ in
                    print("Download tapped")
                    
                    self?.downloadMovieAt(indexPaths: indexPaths)
                }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
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
