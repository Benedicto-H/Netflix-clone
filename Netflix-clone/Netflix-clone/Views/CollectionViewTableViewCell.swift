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
    
    // MARK: - Custom Views
    private let collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 200)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
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

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource - (Required) Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return max(movies.count, tvs.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: TitleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        
        
        func getRandomColor() -> UIColor {
            let randomRed = CGFloat.random(in: 0...1)
            let randomGreen = CGFloat.random(in: 0...1)
            let randomBlue = CGFloat.random(in: 0...1)
            
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
        
        
        cell.backgroundColor = getRandomColor()
        
        if indexPath.row < movies.count {
            
            cell.configure(with: movies[indexPath.row].poster_path ?? "")
        }
        
        if indexPath.row < tvs.count {
            
            cell.configure(with: tvs[indexPath.row].poster_path ?? "")
        }
        
        return cell
    }
}
