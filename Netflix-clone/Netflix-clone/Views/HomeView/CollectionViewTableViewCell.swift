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
    
    private var movies: [MoviesResponse.Movie] = [MoviesResponse.Movie]()
    private var tvs: [TVsResponse.TV] = [TVsResponse.TV]()
    
    // MARK: - Custom View
    private let collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        //  layout.itemSize = CGSize(width: 120, height: 200)   //  Line 71~77
        
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
    
    
    public func configure(withMovies movies: [MoviesResponse.Movie]?, withTVs tvs: [TVsResponse.TV]?) -> Void {
        
        self.movies = movies ?? []
        self.tvs = tvs ?? []
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegateFlowLayout = (optional) Method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (contentView.frame.size.width) / 3, height: contentView.frame.size.height)
    }
    
    // MARK: - UICollectionViewDataSource - (Required) Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return max(movies.count, tvs.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        //  cell.backgroundColor = .black
        
        if (indexPath.row < movies.count) {
            
            cell.configure(with: movies[indexPath.row].poster_path ?? "")
        }
        
        if (indexPath.row < tvs.count) {
            
            cell.configure(with: tvs[indexPath.row].poster_path ?? "")
        }
        
        return cell
    }
}
